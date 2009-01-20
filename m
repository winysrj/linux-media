Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:16212
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbZATWWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:22:19 -0500
Message-ID: <11139700E10D4426B6C6CBD6662290F8@mce>
From: "drappa" <drappa@iinet.net.au>
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
Subject: Re: DVICO Dual Digital 4 DVB-T Revision2 : Strange Remote Control Issue
Date: Wed, 21 Jan 2009 07:47:24 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi All
>
> I have one of these cards running perfectly in a current Mythbuntu 8.10 
> system.
> Yesterday, I needed to run it under MS VISTA in a dual boot system for 
> some testing.
> The VISTA installation proved problematical but the main issue is that the 
> IR Remote will no longer function under VISTA.
> I tried rolling back to previous versions of the DVICO drivers but still 
> nothing.
> Booted back into Mythbuntu and the remote was fine.
> I'm at a loss to understand why. Is anything written to firmware when the 
> card is installed in a Linux system?
>
> Regards
> Drappa

In Antti Palosaari's reply to the post "Re: [linux-dvb] getting started with 
msi tv cards" He says, "All remote keys are not working because driver does
not upload IR-table to the chip"
>From this I am unsure if the same applies to the operation of the DVICO card 
and if tables are uploaded into volatile memory on each load or if they are 
written to firmware. However it does seem to provide a clue towards 
answering my question while raising an area of general concern.

My questions are:-
Does the current v4l-dvd driver supporting the DVICO Dual Express Rev. 2 
card upload remote control tables to the firmware?
If so, is it possible that this has the unwanted effect of preventing the 
DVICO remote control software from loading when the card is re-installed 
into a windows machine?
Is there a way to test this and/or reset  the card to its original state?

