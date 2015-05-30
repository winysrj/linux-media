Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57523 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563AbbE3MUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2015 08:20:49 -0400
Message-ID: <5569AB11.2070608@xs4all.nl>
Date: Sat, 30 May 2015 14:20:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	David Howells <dhowells@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 19/35] DocBook: Fix false positive undefined ioctl references
References: <cover.1432844837.git.mchehab@osg.samsung.com> <38cdfa7a55aabcecd69b7e6d79021f014be2576a.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <38cdfa7a55aabcecd69b7e6d79021f014be2576a.1432844837.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2015 11:49 PM, Mauro Carvalho Chehab wrote:
> The new code that detects undocumented ioctls hits some false
> positives:
> 
> This one is not documented, nor it should, as this is
> there just to reserve namespace:
> 
> 	Warning: can't find reference for VIDIOC_RESERVED ioctl
> 
> But those are already documented together with other ioctls:
> 
> 	Warning: can't find reference for VIDIOC_UNSUBSCRIBE_EVENT ioctl
> 	Warning: can't find reference for FE_GET_PROPERTY ioctl
> 	Warning: can't find reference for VIDIOC_SUBDEV_G_EDID ioctl
> 	Warning: can't find reference for VIDIOC_SUBDEV_S_EDID ioctl
> 	Warning: can't find reference for VIDIOC_SUBDEV_S_DV_TIMINGS ioctl
> 	Warning: can't find reference for VIDIOC_SUBDEV_G_DV_TIMINGS ioctl
> 	Warning: can't find reference for VIDIOC_SUBDEV_QUERY_DV_TIMINGS ioctl
> 
> So, we need to just be sure to point to the right documentation.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index c82e051f2821..e07e8844efde 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -296,7 +296,7 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
>  	@(								\
>  	echo -e "\n<!-- Ioctls -->") >>$@
>  	@(								\
> -	for ident in $(IOCTLS) ; do					\
> +	for ident in `echo $(IOCTLS) | sed -e "s,VIDIOC_RESERVED,,"`; do\
>  	  entity=`echo $$ident | tr _ -` ;				\
>  	  id=`grep -e "<refname>$$ident" -e "<section id=\"$$ident\"" $$(find $(MEDIA_SRC_DIR) -name *.xml -type f)| sed -r s,"^.*/(.*).xml.*","\1",` ; \
>  	  if [ "$$id" != "" ]; then echo "<!ENTITY $$entity \"<link"	\
> diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
> index bb86a74ed7fe..48faf5089675 100644
> --- a/Documentation/DocBook/media/dvb/dvbproperty.xml
> +++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
> @@ -1255,7 +1255,8 @@ enum fe_interleaving {
>    </refmeta>
>  
>    <refnamediv>
> -    <refname>FE_SET_PROPERTY and FE_GET_PROPERTY</refname>
> +      <refname>FE_SET_PROPERTY</refname>
> +      <refname>FE_GET_PROPERTY</refname>
>      <refpurpose>FE_SET_PROPERTY sets one or more frontend properties.
>  	FE_GET_PROPERTY returns one or more frontend properties.</refpurpose>
>    </refnamediv>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> index 764b635ed4cf..06952d7cc770 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> @@ -7,6 +7,8 @@
>    <refnamediv>
>      <refname>VIDIOC_G_DV_TIMINGS</refname>
>      <refname>VIDIOC_S_DV_TIMINGS</refname>
> +    <refname>VIDIOC_SUBDEV_G_DV_TIMINGS</refname>
> +    <refname>VIDIOC_SUBDEV_S_DV_TIMINGS</refname>
>      <refpurpose>Get or set DV timings for input or output</refpurpose>
>    </refnamediv>
>  
> @@ -34,7 +36,7 @@
>        <varlistentry>
>  	<term><parameter>request</parameter></term>
>  	<listitem>
> -	  <para>VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS</para>
> +	  <para>VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS, VIDIOC_SUBDEV_G_DV_TIMINGS, VIDIOC_SUBDEV_S_DV_TIMINGS</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
> index e44340c1f9f7..2702536bbc7c 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
> @@ -7,6 +7,8 @@
>    <refnamediv>
>      <refname>VIDIOC_G_EDID</refname>
>      <refname>VIDIOC_S_EDID</refname>
> +    <refname>VIDIOC_SUBDEV_G_EDID</refname>
> +    <refname>VIDIOC_SUBDEV_S_EDID</refname>
>      <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
>    </refnamediv>
>  
> @@ -42,7 +44,7 @@
>        <varlistentry>
>  	<term><parameter>request</parameter></term>
>  	<listitem>
> -	  <para>VIDIOC_G_EDID, VIDIOC_S_EDID</para>
> +	  <para>VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> index e185f149e0a1..e9c70a8f3476 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> @@ -6,6 +6,7 @@
>  
>    <refnamediv>
>      <refname>VIDIOC_QUERY_DV_TIMINGS</refname>
> +    <refname>VIDIOC_SUBDEV_QUERY_DV_TIMINGS</refname>
>      <refpurpose>Sense the DV preset received by the current
>  input</refpurpose>
>    </refnamediv>
> @@ -34,7 +35,7 @@ input</refpurpose>
>        <varlistentry>
>  	<term><parameter>request</parameter></term>
>  	<listitem>
> -	  <para>VIDIOC_QUERY_DV_TIMINGS</para>
> +	  <para>VIDIOC_QUERY_DV_TIMINGS, VIDIOC_SUBDEV_QUERY_DV_TIMINGS</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> index d0332f610929..5fd0ee78f880 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> @@ -5,7 +5,8 @@
>    </refmeta>
>  
>    <refnamediv>
> -    <refname>VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT</refname>
> +      <refname>VIDIOC_SUBSCRIBE_EVENT</refname>
> +      <refname>VIDIOC_UNSUBSCRIBE_EVENT</refname>
>      <refpurpose>Subscribe or unsubscribe event</refpurpose>
>    </refnamediv>
>  
> 

