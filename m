Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:44640 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBGJEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 04:04:31 -0500
Received: by mail-ig0-f178.google.com with SMTP id uq10so1495106igb.5
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 01:04:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk>
	<E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk>
Date: Fri, 7 Feb 2014 10:04:30 +0100
Message-ID: <CAKMK7uFYhz8Pmv5E7aKY7yzZGDe_m8a0382Njv7tZRoBSfmRpw@mail.gmail.com>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
 componentised subsystems
From: Daniel Vetter <daniel@ffwll.ch>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've chatted a bit with Hans Verkuil about this topic at fosdem and
apparently both v4l and alsa have something like this already in their
helper libraries. Adding more people as fyi in case they want to
switch to the new driver core stuff from Russell.
-Daniel

On Thu, Jan 2, 2014 at 10:27 PM, Russell King
<rmk+kernel@arm.linux.org.uk> wrote:
> Subsystems such as ALSA, DRM and others require a single card-level
> device structure to represent a subsystem.  However, firmware tends to
> describe the individual devices and the connections between them.
>
> Therefore, we need a way to gather up the individual component devices
> together, and indicate when we have all the component devices.
>
> We do this in DT by providing a "superdevice" node which specifies
> the components, eg:
>
>         imx-drm {
>                 compatible = "fsl,drm";
>                 crtcs = <&ipu1>;
>                 connectors = <&hdmi>;
>         };
>
> The superdevice is declared into the component support, along with the
> subcomponents.  The superdevice receives callbacks to locate the
> subcomponents, and identify when all components are present.  At this
> point, we bind the superdevice, which causes the appropriate subsystem
> to be initialised in the conventional way.
>
> When any of the components or superdevice are removed from the system,
> we unbind the superdevice, thereby taking the subsystem down.
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/base/Makefile     |    2 +-
>  drivers/base/component.c  |  379 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/component.h |   31 ++++
>  3 files changed, 411 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/base/component.c
>  create mode 100644 include/linux/component.h
>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 94e8a80e87f8..870ecfd503af 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -1,6 +1,6 @@
>  # Makefile for the Linux device tree
>
> -obj-y                  := core.o bus.o dd.o syscore.o \
> +obj-y                  := component.o core.o bus.o dd.o syscore.o \
>                            driver.o class.o platform.o \
>                            cpu.o firmware.o init.o map.o devres.o \
>                            attribute_container.o transport_class.o \
> diff --git a/drivers/base/component.c b/drivers/base/component.c
> new file mode 100644
> index 000000000000..5492cd8d2247
> --- /dev/null
> +++ b/drivers/base/component.c
> @@ -0,0 +1,379 @@
> +/*
> + * Componentized device handling.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This is work in progress.  We gather up the component devices into a list,
> + * and bind them when instructed.  At the moment, we're specific to the DRM
> + * subsystem, and only handles one master device, but this doesn't have to be
> + * the case.
> + */
> +#include <linux/component.h>
> +#include <linux/device.h>
> +#include <linux/kref.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +struct master {
> +       struct list_head node;
> +       struct list_head components;
> +       bool bound;
> +
> +       const struct component_master_ops *ops;
> +       struct device *dev;
> +};
> +
> +struct component {
> +       struct list_head node;
> +       struct list_head master_node;
> +       struct master *master;
> +       bool bound;
> +
> +       const struct component_ops *ops;
> +       struct device *dev;
> +};
> +
> +static DEFINE_MUTEX(component_mutex);
> +static LIST_HEAD(component_list);
> +static LIST_HEAD(masters);
> +
> +static struct master *__master_find(struct device *dev, const struct component_master_ops *ops)
> +{
> +       struct master *m;
> +
> +       list_for_each_entry(m, &masters, node)
> +               if (m->dev == dev && (!ops || m->ops == ops))
> +                       return m;
> +
> +       return NULL;
> +}
> +
> +/* Attach an unattached component to a master. */
> +static void component_attach_master(struct master *master, struct component *c)
> +{
> +       c->master = master;
> +
> +       list_add_tail(&c->master_node, &master->components);
> +}
> +
> +/* Detach a component from a master. */
> +static void component_detach_master(struct master *master, struct component *c)
> +{
> +       list_del(&c->master_node);
> +
> +       c->master = NULL;
> +}
> +
> +int component_master_add_child(struct master *master,
> +       int (*compare)(struct device *, void *), void *compare_data)
> +{
> +       struct component *c;
> +       int ret = -ENXIO;
> +
> +       list_for_each_entry(c, &component_list, node) {
> +               if (c->master)
> +                       continue;
> +
> +               if (compare(c->dev, compare_data)) {
> +                       component_attach_master(master, c);
> +                       ret = 0;
> +                       break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(component_master_add_child);
> +
> +/* Detach all attached components from this master */
> +static void master_remove_components(struct master *master)
> +{
> +       while (!list_empty(&master->components)) {
> +               struct component *c = list_first_entry(&master->components,
> +                                       struct component, master_node);
> +
> +               WARN_ON(c->master != master);
> +
> +               component_detach_master(master, c);
> +       }
> +}
> +
> +/*
> + * Try to bring up a master.  If component is NULL, we're interested in
> + * this master, otherwise it's a component which must be present to try
> + * and bring up the master.
> + *
> + * Returns 1 for successful bringup, 0 if not ready, or -ve errno.
> + */
> +static int try_to_bring_up_master(struct master *master,
> +       struct component *component)
> +{
> +       int ret = 0;
> +
> +       if (!master->bound) {
> +               /*
> +                * Search the list of components, looking for components that
> +                * belong to this master, and attach them to the master.
> +                */
> +               if (master->ops->add_components(master->dev, master)) {
> +                       /* Failed to find all components */
> +                       master_remove_components(master);
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               if (component && component->master != master) {
> +                       master_remove_components(master);
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               /* Found all components */
> +               ret = master->ops->bind(master->dev);
> +               if (ret < 0) {
> +                       master_remove_components(master);
> +                       goto out;
> +               }
> +
> +               master->bound = true;
> +               ret = 1;
> +       }
> +out:
> +
> +       return ret;
> +}
> +
> +static int try_to_bring_up_masters(struct component *component)
> +{
> +       struct master *m;
> +       int ret = 0;
> +
> +       list_for_each_entry(m, &masters, node) {
> +               ret = try_to_bring_up_master(m, component);
> +               if (ret != 0)
> +                       break;
> +       }
> +
> +       return ret;
> +}
> +
> +static void take_down_master(struct master *master)
> +{
> +       if (master->bound) {
> +               master->ops->unbind(master->dev);
> +               master->bound = false;
> +       }
> +
> +       master_remove_components(master);
> +}
> +
> +int component_master_add(struct device *dev, const struct component_master_ops *ops)
> +{
> +       struct master *master;
> +       int ret;
> +
> +       master = kzalloc(sizeof(*master), GFP_KERNEL);
> +       if (!master)
> +               return -ENOMEM;
> +
> +       master->dev = dev;
> +       master->ops = ops;
> +       INIT_LIST_HEAD(&master->components);
> +
> +       /* Add to the list of available masters. */
> +       mutex_lock(&component_mutex);
> +       list_add(&master->node, &masters);
> +
> +       ret = try_to_bring_up_master(master, NULL);
> +
> +       if (ret < 0) {
> +               /* Delete off the list if we weren't successful */
> +               list_del(&master->node);
> +               kfree(master);
> +       }
> +       mutex_unlock(&component_mutex);
> +
> +       return ret < 0 ? ret : 0;
> +}
> +EXPORT_SYMBOL_GPL(component_master_add);
> +
> +void component_master_del(struct device *dev, const struct component_master_ops *ops)
> +{
> +       struct master *master;
> +
> +       mutex_lock(&component_mutex);
> +       master = __master_find(dev, ops);
> +       if (master) {
> +               take_down_master(master);
> +
> +               list_del(&master->node);
> +               kfree(master);
> +       }
> +       mutex_unlock(&component_mutex);
> +}
> +EXPORT_SYMBOL_GPL(component_master_del);
> +
> +static void component_unbind(struct component *component,
> +       struct master *master, void *data)
> +{
> +       WARN_ON(!component->bound);
> +
> +       component->ops->unbind(component->dev, master->dev, data);
> +       component->bound = false;
> +
> +       /* Release all resources claimed in the binding of this component */
> +       devres_release_group(component->dev, component);
> +}
> +
> +void component_unbind_all(struct device *master_dev, void *data)
> +{
> +       struct master *master;
> +       struct component *c;
> +
> +       WARN_ON(!mutex_is_locked(&component_mutex));
> +
> +       master = __master_find(master_dev, NULL);
> +       if (!master)
> +               return;
> +
> +       list_for_each_entry_reverse(c, &master->components, master_node)
> +               component_unbind(c, master, data);
> +}
> +EXPORT_SYMBOL_GPL(component_unbind_all);
> +
> +static int component_bind(struct component *component, struct master *master,
> +       void *data)
> +{
> +       int ret;
> +
> +       /*
> +        * Each component initialises inside its own devres group.
> +        * This allows us to roll-back a failed component without
> +        * affecting anything else.
> +        */
> +       if (!devres_open_group(master->dev, NULL, GFP_KERNEL))
> +               return -ENOMEM;
> +
> +       /*
> +        * Also open a group for the device itself: this allows us
> +        * to release the resources claimed against the sub-device
> +        * at the appropriate moment.
> +        */
> +       if (!devres_open_group(component->dev, component, GFP_KERNEL)) {
> +               devres_release_group(master->dev, NULL);
> +               return -ENOMEM;
> +       }
> +
> +       dev_dbg(master->dev, "binding %s (ops %ps)\n",
> +               dev_name(component->dev), component->ops);
> +
> +       ret = component->ops->bind(component->dev, master->dev, data);
> +       if (!ret) {
> +               component->bound = true;
> +
> +               /*
> +                * Close the component device's group so that resources
> +                * allocated in the binding are encapsulated for removal
> +                * at unbind.  Remove the group on the DRM device as we
> +                * can clean those resources up independently.
> +                */
> +               devres_close_group(component->dev, NULL);
> +               devres_remove_group(master->dev, NULL);
> +
> +               dev_info(master->dev, "bound %s (ops %ps)\n",
> +                        dev_name(component->dev), component->ops);
> +       } else {
> +               devres_release_group(component->dev, NULL);
> +               devres_release_group(master->dev, NULL);
> +
> +               dev_err(master->dev, "failed to bind %s (ops %ps): %d\n",
> +                       dev_name(component->dev), component->ops, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +int component_bind_all(struct device *master_dev, void *data)
> +{
> +       struct master *master;
> +       struct component *c;
> +       int ret = 0;
> +
> +       WARN_ON(!mutex_is_locked(&component_mutex));
> +
> +       master = __master_find(master_dev, NULL);
> +       if (!master)
> +               return -EINVAL;
> +
> +       list_for_each_entry(c, &master->components, master_node) {
> +               ret = component_bind(c, master, data);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (ret != 0) {
> +               list_for_each_entry_continue_reverse(c, &master->components,
> +                                                    master_node)
> +                       component_unbind(c, master, data);
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(component_bind_all);
> +
> +int component_add(struct device *dev, const struct component_ops *ops)
> +{
> +       struct component *component;
> +       int ret;
> +
> +       component = kzalloc(sizeof(*component), GFP_KERNEL);
> +       if (!component)
> +               return -ENOMEM;
> +
> +       component->ops = ops;
> +       component->dev = dev;
> +
> +       dev_dbg(dev, "adding component (ops %ps)\n", ops);
> +
> +       mutex_lock(&component_mutex);
> +       list_add_tail(&component->node, &component_list);
> +
> +       ret = try_to_bring_up_masters(component);
> +       if (ret < 0) {
> +               list_del(&component->node);
> +
> +               kfree(component);
> +       }
> +       mutex_unlock(&component_mutex);
> +
> +       return ret < 0 ? ret : 0;
> +}
> +EXPORT_SYMBOL_GPL(component_add);
> +
> +void component_del(struct device *dev, const struct component_ops *ops)
> +{
> +       struct component *c, *component = NULL;
> +
> +       mutex_lock(&component_mutex);
> +       list_for_each_entry(c, &component_list, node)
> +               if (c->dev == dev && c->ops == ops) {
> +                       list_del(&c->node);
> +                       component = c;
> +                       break;
> +               }
> +
> +       if (component && component->master)
> +               take_down_master(component->master);
> +
> +       mutex_unlock(&component_mutex);
> +
> +       WARN_ON(!component);
> +       kfree(component);
> +}
> +EXPORT_SYMBOL_GPL(component_del);
> +
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/component.h b/include/linux/component.h
> new file mode 100644
> index 000000000000..73657636db0b
> --- /dev/null
> +++ b/include/linux/component.h
> @@ -0,0 +1,31 @@
> +#ifndef COMPONENT_H
> +#define COMPONENT_H
> +
> +struct device;
> +
> +struct component_ops {
> +       int (*bind)(struct device *, struct device *, void *);
> +       void (*unbind)(struct device *, struct device *, void *);
> +};
> +
> +int component_add(struct device *, const struct component_ops *);
> +void component_del(struct device *, const struct component_ops *);
> +
> +int component_bind_all(struct device *, void *);
> +void component_unbind_all(struct device *, void *);
> +
> +struct master;
> +
> +struct component_master_ops {
> +       int (*add_components)(struct device *, struct master *);
> +       int (*bind)(struct device *);
> +       void (*unbind)(struct device *);
> +};
> +
> +int component_master_add(struct device *, const struct component_master_ops *);
> +void component_master_del(struct device *, const struct component_master_ops *);
> +
> +int component_master_add_child(struct master *master,
> +       int (*compare)(struct device *, void *), void *compare_data);
> +
> +#endif
> --
> 1.7.4.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
