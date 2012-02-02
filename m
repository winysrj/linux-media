Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33402 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2BBXMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 18:12:18 -0500
Received: by eaah12 with SMTP id h12so1244009eaa.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 15:12:17 -0800 (PST)
Message-ID: <4F2B184F.4030709@gmail.com>
Date: Fri, 03 Feb 2012 00:12:15 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org> <4F2ADDCB.4060200@gmail.com> <4F2AEA81.90506@ukfsn.org>
In-Reply-To: <4F2AEA81.90506@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 02/02/2012 20:56, Andy Furniss ha scritto:
> Gianluca Gennari wrote:
> 
>> Hi Andy,
>> I'm getting the same problem on a totally different system.
> 
> Hi Gianluca,
> 
> Thanks for the reply - it's good to know it's not just me.
> 
> What kernel are you using?
> 
> I see someone else had problems with > 3.0, I've got a 3.08 built on
> this box, I'll try it out when I get a chance to reboot, though it took
> a couple of days to show on my current kernel.
> 
> Andy.
> 

Hi Andy,
I'm running 3.1.0 but I back-ported a few patches from 3.2.0 to update
the PCTV 290e driver to the latest version.
In the past months I run 2.6.18/2.6.31/3.0.3 before buying the PCTV
290e, but I never had this problem with the old dvb-usb stick.

Regards,
Gianluca


