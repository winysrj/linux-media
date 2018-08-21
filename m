Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37315 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725732AbeHUEC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 00:02:59 -0400
Received: by mail-qt0-f193.google.com with SMTP id n6-v6so18403008qtl.4
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 17:45:08 -0700 (PDT)
Message-ID: <7ac54c075962760d24b6ed99ba5b0485a80d8f3f.camel@redhat.com>
Subject: Re: [PATCH (repost) 1/5] drm_dp_cec: check that aux has a transfer
 function
From: Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date: Mon, 20 Aug 2018 20:45:05 -0400
In-Reply-To: <ad4cd65b-4bb2-4b6c-2bc6-dc0c228c76aa@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
         <20180817141122.9541-2-hverkuil@xs4all.nl>
         <875a995712d0de615f47f200863376ee617ec533.camel@redhat.com>
         <ad4cd65b-4bb2-4b6c-2bc6-dc0c228c76aa@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-08-20 at 22:47 +0200, Hans Verkuil wrote:
> On 08/20/2018 08:51 PM, Lyude Paul wrote:
> > On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > If aux->transfer == NULL, then just return without doing
> > > anything. In that case the function is likely called for
> > > a non-(e)DP connector.
> > > 
> > > This never happened for the i915 driver, but the nouveau and amdgpu
> > > drivers need this check.
> > 
> > Could you give a backtrace from where you're hitting this issue with nouveau
> > and
> > amdgpu? It doesn't make a whole ton of sense to have connectors registering
> > DP
> > aux busses if they aren't actually DP, that should probably just be fixed...
> 
Agh, nouveau and amdgpu making questionable decisions :s... but I suppose that
makes sense.

Reviewed-by: Lyude Paul <lyude@redhat.com>

> The difference between the i915 driver and the nouveau (and amdgpu) driver is
> that in the i915 driver the drm_dp_cec_set_edid/unset_edid/irq functions are
> called from code that is exclusively for DisplayPort connectors.
> 
> For nouveau/amdgpu they are called from code that is shared between
> DisplayPort
> and HDMI, so aux->transfer may be NULL.
> 
> Rather than either testing for the connector type or for a non-NULL aux-
> >transfer
> every time I call a drm_dp_cec_* function, it is better to just test for
> aux->transfer in the drm_dp_cec_* functions themselves. It's more robust.
> 
> So there isn't a bug or anything like that, it's just so that these drm_dp_cec
> functions can handle a slightly different driver design safely.
> 
> The registration and unregistration of the cec devices is always DP specific,
> and an attempt to register a cec device for a non-DP connector will now fail
> with a WARN_ON.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > > 
> > > The alternative would be to add this check in those drivers before
> > > every drm_dp_cec call, but it makes sense to check it in the
> > > drm_dp_cec functions to prevent a kernel oops.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > >  drivers/gpu/drm/drm_dp_cec.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> > > index 988513346e9c..1407b13a8d5d 100644
> > > --- a/drivers/gpu/drm/drm_dp_cec.c
> > > +++ b/drivers/gpu/drm/drm_dp_cec.c
> > > @@ -238,6 +238,10 @@ void drm_dp_cec_irq(struct drm_dp_aux *aux)
> > >  	u8 cec_irq;
> > >  	int ret;
> > >  
> > > +	/* No transfer function was set, so not a DP connector */
> > > +	if (!aux->transfer)
> > > +		return;
> > > +
> > >  	mutex_lock(&aux->cec.lock);
> > >  	if (!aux->cec.adap)
> > >  		goto unlock;
> > > @@ -293,6 +297,10 @@ void drm_dp_cec_set_edid(struct drm_dp_aux *aux,
> > > const
> > > struct edid *edid)
> > >  	unsigned int num_las = 1;
> > >  	u8 cap;
> > >  
> > > +	/* No transfer function was set, so not a DP connector */
> > > +	if (!aux->transfer)
> > > +		return;
> > > +
> > >  #ifndef CONFIG_MEDIA_CEC_RC
> > >  	/*
> > >  	 * CEC_CAP_RC is part of CEC_CAP_DEFAULTS, but it is stripped by
> > > @@ -361,6 +369,10 @@ EXPORT_SYMBOL(drm_dp_cec_set_edid);
> > >   */
> > >  void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
> > >  {
> > > +	/* No transfer function was set, so not a DP connector */
> > > +	if (!aux->transfer)
> > > +		return;
> > > +
> > >  	cancel_delayed_work_sync(&aux->cec.unregister_work);
> > >  
> > >  	mutex_lock(&aux->cec.lock);
> > > @@ -404,6 +416,8 @@ void drm_dp_cec_register_connector(struct drm_dp_aux
> > > *aux,
> > > const char *name,
> > >  				   struct device *parent)
> > >  {
> > >  	WARN_ON(aux->cec.adap);
> > > +	if (WARN_ON(!aux->transfer))
> > > +		return;
> > >  	aux->cec.name = name;
> > >  	aux->cec.parent = parent;
> > >  	INIT_DELAYED_WORK(&aux->cec.unregister_work,
> 
> 
