Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f189.google.com ([209.85.210.189]:38633 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab0BCGUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 01:20:22 -0500
Received: by yxe27 with SMTP id 27so865651yxe.4
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2010 22:20:21 -0800 (PST)
Message-ID: <4B69159D.2040606@gmail.com>
Date: Wed, 03 Feb 2010 14:20:13 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com>
In-Reply-To: <4B6817E6.4070709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> I'm assuming that you're referring to the analog part, right?
>    
right.
  The country code only effects the Analog TV and radio, it has no 
effect on DVB-T.

> Instead of a country code, the driver should use the V4L2_STD_ macros to
>    
If we are in the radio mode, I do not have any video standard, how can I 
choose
the right audio setting in this situation?


> determine the audio standard. Please take a look at saa7134-tvaudio code. It has
> an interesting logic to associate the V4L2_STD with the corresponding audio settings:
>
> For example, the audio carrier frequency and the audio standard are at tvaudio array:
>    tatic struct saa7134_tvaudio tvaudio[] = {
>    

