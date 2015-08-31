Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59377 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbbHaLWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:22:43 -0400
Message-ID: <55E438CB.1000204@xs4all.nl>
Date: Mon, 31 Aug 2015 13:21:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 30/55] [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
References: <cover.1440902901.git.mchehab@osg.samsung.com> <95f10058c1c2e5b511e5eb4ce890b821ed0697f9.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <95f10058c1c2e5b511e5eb4ce890b821ed0697f9.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Now that interfaces and entities are distinct, it makes no sense
> of keeping something named as MEDIA_ENT_T_DEVNODE_DVB_foo.
> 
> Made via this script:
> 	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DEVNODE_DVB_,MEDIA_ENT_T_DVB_, <$i >a && mv a $i; done
> 	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_DVR,MEDIA_ENT_T_DVB_TSOUT, <$i >a && mv a $i; done
> 	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_FE,MEDIA_ENT_T_DVB_DEMOD, <$i >a && mv a $i; done
> 	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DVB_NET,MEDIA_ENT_T_DVB_DEMOD_NET_DECAP, <$i >a && mv a $i; done
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 910243d4edb8..32a783635649 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -195,23 +195,23 @@
>  	    <entry>ALSA card</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_FE</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
>  	    <entry>DVB frontend devnode</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DEMUX</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
>  	    <entry>DVB demux devnode</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_DVR</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
>  	    <entry>DVB DVR devnode</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_CA</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
>  	    <entry>DVB CAM devnode</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_DVB_NET</constant></entry>
> +	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
>  	    <entry>DVB network devnode</entry>
>  	  </row>
>  	  <row>
> 

