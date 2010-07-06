Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0GFCoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 22:44:11 -0400
Message-ID: <4C32987B.10307@redhat.com>
Date: Mon, 05 Jul 2010 23:44:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Subject: Re: [PATCH v4 5/5] Documentation: v4l: Add hw_seek spacing.
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-3-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-4-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-5-git-send-email-matti.j.aaltonen@nokia.com> <1275647663-20650-6-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1275647663-20650-6-git-send-email-matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-06-2010 07:34, Matti J. Aaltonen escreveu:
> Add a couple of words about the spacing field in HW seek struct.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> index 14b3ec7..8ee614c 100644
> --- a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> +++ b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> @@ -51,7 +51,8 @@
>  
>      <para>Start a hardware frequency seek from the current frequency.
>  To do this applications initialize the <structfield>tuner</structfield>,
> -<structfield>type</structfield>, <structfield>seek_upward</structfield> and
> +<structfield>type</structfield>, <structfield>seek_upward</structfield>,
> +<structfield>spacing</structfield> and
>  <structfield>wrap_around</structfield> fields, and zero out the
>  <structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
>  call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
> @@ -89,7 +90,12 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[8]</entry>
> +	    <entry><structfield>spacing</structfield></entry>
> +	    <entry>If non-zero, gives the search resolution to be used in hardware scan. The driver selects the nearest value that is supported by the hardware. If spacing is zero use a reasonable default value.</entry>

What's the unit for spacing?

> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[7]</entry>
>  	    <entry>Reserved for future extensions. Drivers and
>  	    applications must set the array to zero.</entry>
>  	  </row>

