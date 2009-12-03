Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45230 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZLCMcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 07:32:03 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NGAqu-0006nd-4g
	for linux-media@vger.kernel.org; Thu, 03 Dec 2009 13:32:08 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 13:32:08 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 13:32:08 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: Re: /dev/dvb/adapter0/net0 <-- what is this for and how to use it?
Date: Thu, 03 Dec 2009 13:31:30 +0100
Message-ID: <4B17AFA2.6020302@gmail.com>
References: <8cd7f1780912030021q182347ebr6bc8be8536c5d53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-media@vger.kernel.org
In-Reply-To: <8cd7f1780912030021q182347ebr6bc8be8536c5d53@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Leszek Koltunski wrote, On 12/03/2009 09:21 AM:
> Hello DVB gurus,
> 
> I've got a TwinHan DVB-S2 card. I compiled the 'liplianin' drivers and
> it's working nicely; thanks for all your work!
> 
> One question: in /dev/dvb/adapter0 I can see
> 
> leszek@satellite:~$ ls -l /dev/dvb/adapter0/
> total 0
> crw-rw----+ 1 root video 212, 4 2009-12-02 18:22 ca0
> crw-rw----+ 1 root video 212, 0 2009-12-02 18:22 demux0
> crw-rw----+ 1 root video 212, 1 2009-12-02 18:22 dvr0
> crw-rw----+ 1 root video 212, 3 2009-12-02 18:22 frontend0
> crw-rw----+ 1 root video 212, 2 2009-12-02 18:22 net0
> 
> What is this 'net0' device and how do I use it? Can I use it to
> directly multicast my (FTA) satellite stream to my lan by any chance?

You can use MuMuDVB for this: http://mumudvb.braice.net/

And net0 is related to network over dvb. look at the dvbnet tool (in
dvb-apps package)

Pierre

> 
> I have found no documentation about this...

