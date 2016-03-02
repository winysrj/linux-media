Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57505 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbcCBQYp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 11:24:45 -0500
Subject: Re: [RFC] Representing hardware connections via MC
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <20160226091317.5a07c374@recife.lan>
 <20160302141643.GH11084@valkosipuli.retiisi.org.uk>
 <20160302124029.0e6cee85@recife.lan> <20160302130409.60df670f@recife.lan>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <56D713C6.2040707@osg.samsung.com>
Date: Wed, 2 Mar 2016 13:24:38 -0300
MIME-Version: 1.0
In-Reply-To: <20160302130409.60df670f@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 03/02/2016 01:04 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 2 Mar 2016 12:40:29 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>
>> After all the discussions, I guess "CONN" for connection is the best way
>> to represent it.
>

I agree, after all in the latest proposal, the entity is really a connection
(or set of connections as for example in a S-Video with separate Y and C)
and the pads are the ones modeling the carrying signals.

Just some small typos mentioned below.

> Better to put it on a patch.
>
> Please review.
>
> Regards,
> Mauro
>
> [media] Better define MEDIA_ENT_F_CONN_* entities
>
> Putting concepts in a paper is hard, specially since different people
> may interpret it in a different way.
>
> Make clear about the meaning of the MEDIA_ENT_F_CONN_* entities
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 5e3f20fdcf17..b036e6103949 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -46,15 +46,26 @@
>   	  </row>
>   	  <row>
>   	    <entry><constant>MEDIA_ENT_F_CONN_RF</constant></entry>
> -	    <entry>Connector for a Radio Frequency (RF) signal.</entry>
> +	    <entry>Entity representing the logical connection associated with a
> +		    single Radio Frequency (RF) signal connector. It
> +		    corresponds to the logical input or output associated
> +		    with the RF signal.</entry>
>   	  </row>
>   	  <row>
>   	    <entry><constant>MEDIA_ENT_F_CONN_SVIDEO</constant></entry>
> -	    <entry>Connector for a S-Video signal.</entry>
> +	    <entry>Entity representing the logical connection assowiated

s/assowiated/associated

> +		    with a sigle S-Video connector. Such entity should have
> +		    two pads, one for the luminance signal(Y) and one
> +		    for the chrominance signal (C). It corresponds to the

s/luminance signal(Y)/luminance signal (Y)

> +		    logical input or output associated with S-Video Y and C
> +		    signals.</entry>
>   	  </row>
>   	  <row>
>   	    <entry><constant>MEDIA_ENT_F_CONN_COMPOSITE</constant></entry>
> -	    <entry>Connector for a RGB composite signal.</entry>
> +	    <entry>Entity representing the logical connection for a composite
> +		    signal. It corresponds to the logical input or output
> +		    associated with the a single signal that carries both

s/a/

> +		    chrominance and luminance information (Y+C).</entry>
>   	  </row>
>   	  <row>
>   	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
