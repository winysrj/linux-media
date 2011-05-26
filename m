Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41879 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab1EZNsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 09:48:42 -0400
Received: by qwk3 with SMTP id 3so364667qwk.19
        for <linux-media@vger.kernel.org>; Thu, 26 May 2011 06:48:41 -0700 (PDT)
References: <1306305788.2390.4.camel@porites> <1306359272-30792-1-git-send-email-jarod@redhat.com> <20110526084912.1ac3ac37@tele>
In-Reply-To: <20110526084912.1ac3ac37@tele>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <367523C9-4560-4E50-A186-B20674AD081D@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] [media] gspca/kinect: wrap gspca_debug with GSPCA_DEBUG
Date: Thu, 26 May 2011 09:48:48 -0400
To: jean-francois Moine <moinejf@free.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 26, 2011, at 2:49 AM, jean-francois Moine wrote:

> On Wed, 25 May 2011 17:34:32 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
> 
>> diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
>> index 66671a4..26fc206 100644
>> --- a/drivers/media/video/gspca/kinect.c
>> +++ b/drivers/media/video/gspca/kinect.c
>> @@ -34,7 +34,7 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
>> MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
>> MODULE_LICENSE("GPL");
>> 
>> -#ifdef DEBUG
>> +#ifdef GSPCA_DEBUG
>> int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
>> 	D_USBI | D_USBO | D_V4L2;
>> #endif
> 
> Hi Jarod,
> 
> Sorry, it is not the right fix. In fact, the variable gspca_debug must
> not be defined in gspca subdrivers:
> 
> --- a/drivers/media/video/gspca/kinect.c
> +++ b/drivers/media/video/gspca/kinect.c
> @@ -34,11 +34,6 @@
> MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
> MODULE_LICENSE("GPL");
> 
> -#ifdef DEBUG
> -int gspca_debug = D_ERR | D_PROBE | D_CONF | D_STREAM | D_FRAM | D_PACK |
> -	D_USBI | D_USBO | D_V4L2;
> -#endif
> -
> struct pkt_hdr {
> 	uint8_t magic[2];
> 	uint8_t pad;

Ah, ok, that works just as well for me, since I don't have the hardware,
was just looking to make sure things still complied. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



