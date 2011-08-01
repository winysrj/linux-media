Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44603 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1HAXwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 19:52:41 -0400
Received: by gyh3 with SMTP id 3so3777107gyh.19
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2011 16:52:40 -0700 (PDT)
Message-ID: <4E373C44.5060004@rabbitears.info>
Date: Mon, 01 Aug 2011 19:52:36 -0400
From: Trip Ericson <webmaster@rabbitears.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: New Tuner: Hauppauge Aero-M
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all:

I've recently purchased a Hauppauge Aero-M. It is an ATSC USB receiver 
that decodes both regular ATSC and the upcoming ATSC-MH standard.

I am mainly concerned with the ATSC half of it as it has the latest LG 
chip, meaning it is likely one of the best tuners available at present.  
This tuner scans in as 2040:c61b and does not seem to work in Linux at 
present, though it is detected in dmesg. I spoke with a friend who works 
for a broadcaster and he said:

"I did some more checking and see that the MXL5007 does have a Linux 
driver. That's the tuner that's used in the MXF111 so it shouldn't need 
a lot of rewrite. The only thing that needs all new code is the USB 
interface portion of the MXF111."

This gave me hope that maybe at least the ATSC side could be made to 
work with Linux without much trouble. I am not a programmer and know 
basically nothing beyond web coding, but I was wondering if someone 
could perhaps put some time into getting this up and running. I am glad 
to provide any output that is required and perform any testing that is 
requested.

Thanks, all. =)

- Trip
