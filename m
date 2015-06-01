Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53184 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbbFAJQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 05:16:55 -0400
Message-ID: <556C2300.7000307@xs4all.nl>
Date: Mon, 01 Jun 2015 11:16:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] DocBook: fix FE_SET_PROPERTY ioctl arguments
References: <6fd877748a9c4133e37417061e426188fcb00fea.1433149961.git.mchehab@osg.samsung.com> <c1c3c85ddf60a6d97c122d57d385b4929fcec4b3.1433149961.git.mchehab@osg.samsung.com>
In-Reply-To: <c1c3c85ddf60a6d97c122d57d385b4929fcec4b3.1433149961.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2015 11:12 AM, Mauro Carvalho Chehab wrote:
> FE_SET_PROPERTY/FE_GET_PROPERTY actually expects a struct dtv_properties
> argument.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
> index 7d0bd78f5a24..53a170ed3bd1 100644
> --- a/Documentation/DocBook/media/dvb/fe-get-property.xml
> +++ b/Documentation/DocBook/media/dvb/fe-get-property.xml
> @@ -17,7 +17,7 @@
>  	<funcdef>int <function>ioctl</function></funcdef>
>  	<paramdef>int <parameter>fd</parameter></paramdef>
>  	<paramdef>int <parameter>request</parameter></paramdef>
> -	<paramdef>struct dtv_property *<parameter>argp</parameter></paramdef>
> +	<paramdef>struct dtv_properties *<parameter>argp</parameter></paramdef>

Oops, my fault. It's already merged, but for the record:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>        </funcprototype>
>      </funcsynopsis>
>    </refsynopsisdiv>
> 

