Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58242 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2CJTYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 14:24:16 -0500
Received: by wibhr17 with SMTP id hr17so1609758wib.1
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2012 11:24:15 -0800 (PST)
Message-ID: <4F5BAA5C.8010705@gmail.com>
Date: Sat, 10 Mar 2012 20:24:12 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 3.4] gspca for_v3.4
References: <20120227130606.1f432e7b@tele>	<4F4BE111.6090805@gmail.com>	<20120228120548.186ee4bc@tele>	<4F4CB75F.4050907@samsung.com> <20120310123901.72aaa060@tele>
In-Reply-To: <20120310123901.72aaa060@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2012 12:39 PM, Jean-Francois Moine wrote:
> On Tue, 28 Feb 2012 12:15:43 +0100
> Sylwester Nawrocki<s.nawrocki@samsung.com>  wrote:
> 
>>> I checked the changes in zc3xx.c, and I have made many commits. So, it
>>> would be simpler if you would remove your patch. I could give you a
>>> merged one once the media tree would be updated.
>>
>> OK, if it's easier please carry the patch in your tree. Otherwise, let me
>> handle it after our pull request are included in the media tree.
> 
> Hi Sylwester,
> 
> Here is the merge of your patch (origin media_tree staging/for_v3.4).
> As I have an other patch to do to the driver, I may add it to my
> changes once you have acked it (I have no webcam to test it).

Hi Jean-Francois,

thanks, I have tested your patch, but on the webcam I have (A4TECH PK-835):

[16803.614071] usb 2-1.1: new full speed USB device using ehci_hcd and address 10
[16803.708177] gspca: probing 0ac8:303b
[16804.634470] zc3xx: probe 2wr ov vga 0x0000
[16804.658594] zc3xx: probe sensor -> 0011
[16804.658601] zc3xx: Find Sensor HV7131R
[16804.659099] input: zc3xx as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/input/input13
[16804.659512] gspca: video1 created

the JPEG quality control is disabled. I have removed the following line from 
the patch temporarily:

 +		gspca_dev->ctrl_dis = (1 << QUALITY);

just to see if it appears. Of course due to the automatic transfer control
introduced with patches starting from
http://git.linuxtv.org/media_tree.git/commit/30c73d464a10bee4bb8375bb2ed8cc102c507bb7
the jpeg quality control doesn't do anything useful. 

So I can't really test the patch, but it looks fine for me. And if it's needed
please include it in your other change set. FWIW,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester
