Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39916 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936013AbdCJMC2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 07:02:28 -0500
Date: Fri, 10 Mar 2017 14:01:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 07/15] atmel-isi: remove dependency of the soc-camera
 framework
Message-ID: <20170310120119.GG3220@valkosipuli.retiisi.org.uk>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-8-hverkuil@xs4all.nl>
 <20170310103920.GW3220@valkosipuli.retiisi.org.uk>
 <e9f9a41c-c1bb-dfca-646c-c0c24e99d939@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9f9a41c-c1bb-dfca-646c-c0c24e99d939@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Mar 10, 2017 at 12:25:54PM +0100, Hans Verkuil wrote:
> Slight problem with this. If I make this change, then the of_node_put below
> changes as well:
> 
> @@ -1193,7 +1176,7 @@ static int isi_graph_init(struct atmel_isi *isi)
>  done:
>         if (ret < 0) {
>                 v4l2_async_notifier_unregister(&isi->notifier);
> -               of_node_put(isi->entity.node);
> +               of_node_put(isi->entity.asd.match.of.node);
>         }
> 
> And I get this compiler warning:
> 
>   CC [M]  drivers/media/platform/atmel/atmel-isi.o
> drivers/media/platform/atmel/atmel-isi.c: In function ‘isi_graph_init’:
> drivers/media/platform/atmel/atmel-isi.c:1179:15: warning: passing argument 1 of ‘of_node_put’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
>    of_node_put(isi->entity.asd.match.of.node);
>                ^~~
> In file included from drivers/media/platform/atmel/atmel-isi.c:25:0:
> ./include/linux/of.h:130:20: note: expected ‘struct device_node *’ but argument is of type ‘const struct device_node *’
>  static inline void of_node_put(struct device_node *node) { }
>                     ^~~~~~~~~~~
> 
> 
> Any suggestions? Just keep the entity.node after all?

Yeah, makes sense, I didn't come to think of that.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
