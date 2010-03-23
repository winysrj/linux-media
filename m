Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:42601 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0CWOjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:39:55 -0400
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 23 Mar 2010 20:04:50 +0530
Subject: RE: omap2 camera
Message-ID: <70376CA23424B34D86F1C7DE6B997343017F5D5BDF@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <70376CA23424B34D86F1C7DE6B997343017F5D5BD5@VSHINMSMBX01.vshodc.lntinfotech.com>
 <A24693684029E5489D1D202277BE89445428BE8E@dlee02.ent.ti.com>,<4BA7A72B.9000300@maxwell.research.nokia.com>,<70376CA23424B34D86F1C7DE6B997343017F5D5BD8@VSHINMSMBX01.vshodc.lntinfotech.com>
In-Reply-To: <70376CA23424B34D86F1C7DE6B997343017F5D5BD8@VSHINMSMBX01.vshodc.lntinfotech.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> Thanks, Sergio!

>Thanks for your response. Thanks Sergio.

>> I've only aware of the tcm825x sensor driver that works with the OMAP
>> 2420 camera controller (omap24xxcam) driver.

>Does this also mean that omap24xxcam.ko will *only* work with OMAP2420?
>Or the same driver can be used for OMAP2430 board as well ?  As name suggests, omap24xxcam....

>> So likely you'd need the driver for the sensor you have on that board.
>Okie, I am trying to get that done. I took linux-2.6.14-V5 kernel from linux.omap.com and
>that supports camera on OMAP2430 and it has functional driver for ex3691 sensor.
>I am trying to know if I can forward port that.

I started forward porting that and I found out there is no support for OMAP 2430 i2c-controller with the latest kernel.

I dont understand whether latest kernel at all supports anything on OMAP2430 or not :(

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
