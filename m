Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47066 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbZDBXAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 19:00:00 -0400
Received: by bwz17 with SMTP id 17so738347bwz.37
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 15:59:57 -0700 (PDT)
Date: Thu, 02 Apr 2009 18:59:51 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : epg data grabber
To: linux-media@vger.kernel.org
References: <49D53B8A.7020900@koala.ie>
In-Reply-To: <49D53B8A.7020900@koala.ie> (from simon@koala.ie on Thu Apr  2
	18:26:18 2009)
Message-Id: <1238713191.7516.2@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 02.04.2009 18:26:18, Simon Kenyon a écrit :
> i've been hacking together a epg data grabber
> taking pieces from here, there and everywhere
> 
> the basic idea is to grab data off-air and generate xmltv format xml
> files
> 
> the plan is to support DVB, Freesat, Sky (UK and IT) and 
> MediaHighway1
> and 2
> i have the first two working and am working on the rest
> 
> is this of interest to the linuxtv.org community
> i asked the xmltv people, but they are strictly perl. i do 
> understand.
> 
> very little of this is original work of mine. just some applied 
> google
> 
> and a smidgen of C
> 
> i could put it up on sf.net if there is no room on linutv.org
> 
> if anyone wants the work in progress, then please let me know
> it is big released under GPL 3
> 
> i want to get it out there because i'm pretty soon going to be at the 
> end of my knowledge and would appreciate help
> 

Hi Simon,
I have hacked something for what is supposedly mediaHighway epg (it is 
used on CanalSat Caraibes which is affiliated to Canal Satellite from 
France). I actually have a patch against mythtv (it uses the scanner to 
get the epg directly).
I can provide my patches if needed (will need some time to sort things 
out abit, especially if you want a stand alone version).
Bye
Manu


