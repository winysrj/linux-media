Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45281 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1JRRFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 13:05:42 -0400
Received: by vcge1 with SMTP id e1so692640vcg.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 10:05:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAN7ACT-BmTKU6Z6KSXqC18tTOA27r8RatiqdG4hhD8R=66zwA@mail.gmail.com>
References: <CAAN7ACT-BmTKU6Z6KSXqC18tTOA27r8RatiqdG4hhD8R=66zwA@mail.gmail.com>
Date: Tue, 18 Oct 2011 10:05:41 -0700
Message-ID: <CAAN7ACTiw2ccFGVNP2NgE4zsv6=ovH9s9nCiEhBdf1OPTPSv4g@mail.gmail.com>
Subject: Re: Raw data on beagleboard via isp bypass and ccdc.
From: Andrew Tubbiolo <andrew.tubbiolo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All:
    I'm trying to obtain the raw data stream off an aptina mt9p031 via
bypassing the isp in order to get my data directly from the ccdc on a
beagle xm. I've seen what seem to be 3 different forks stabbing at the
problem. None of the threads seem to indicate what patch train, cross
compile environment, and base kernel source source to draw from.

     So I'm asking if someone can point me to a mt9p031.c file, or
patches to apply to which base version of mt9p031 and what kernel
source distro and what patches I need to apply in order to get a
system that will allow something like media-ctl to obtain a raw data
stream from my detector. FYI, I want the raw data for astronomical
purposes.

Thanks!
Andrew
