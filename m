Return-path: <linux-media-owner@vger.kernel.org>
Received: from hosted-by.2is.nl ([62.221.193.103]:36210 "EHLO jcz.nl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZBRHRd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 02:17:33 -0500
Message-ID: <499BB603.10609@jcz.nl>
Date: Wed, 18 Feb 2009 08:17:23 +0100
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Problem with TV card's sound (SAA7134)
References: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
In-Reply-To: <BAY111-W598DBD904310E159C109CC5B40@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

panagiotis takis_rs wrote:
> Hey!!

Hi,

> I have a problem with my tv card(pinnacle pctv 310i)
> I can see image but i have no sound.
> I have tried both tvtime and kdetv.
>  
> I have found this http://ubuntuforums.org/showthread.php?t=568528 . Is it related with my problem?

<snip>

You probably need a 'loopback' audio-line cable from your TV card to your sound card.
Eg, from tv-card lineout to snd-card linein?


Regards,

Jaap Crezee
