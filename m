Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc2-s17.col0.hotmail.com ([65.55.34.91]:50192 "EHLO
	col0-omc2-s17.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbZLJIhZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 03:37:25 -0500
Message-ID: <COL124-W3374D284D1613BFF7C9620B28D0@phx.gbl>
From: Marco Berizzi <pupilla@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: RE: hauppauge hvr 2200: lost FE_HAS_LOCK
Date: Thu, 10 Dec 2009 09:36:32 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> From: Marco Berizzi
> To: linux-media@vger.kernel.org
> Subject: hauppauge hvr 2200: lost FE_HAS_LOCK
> Date: Mon, 16 Nov 2009 09:43:49 +0100
>
>
> Hi Folks,
>
> I have found a problem with the hauppauge wintv hvr 2200
> on linux 2.6.32-rc7 x86-64.
> When I initialize the second tuner with tzap the first
> lose the FE_HAS_LOCK, and viceversa. Here is an example:
>
> tzap -a 1 "LA7(MBone)"
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> reading channels from file '/root/.tzap/channels.conf'
> tuning to 826000000 Hz
> video pid 0x0101, audio pid 0x0102
> status 00 | signal d5d5 | snr 0044 | ber 0000ffff | unc 00000000 |
> status 1f | signal fdfd | snr 00d7 | ber 00000617 | unc 00000045 | FE_HAS_LOCK
> status 1f | signal fcfc | snr 00c6 | ber 0000094e | unc 00000000 | FE_HAS_LOCK
> status 1f | signal fafa | snr 00a8 | ber 000009db | unc 00000046 | FE_HAS_LOCK
> status 01 | signal 0000 | snr 0005 | ber 0000ffff | unc 00000000 |
> status 1f | signal fdfd | snr 00c6 | ber 000007d8 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal fcfc | snr 00c6 | ber 00000750 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal fcfc | snr 00d7 | ber 0000082c | unc 00000000 | FE_HAS_LOCK
> status 1f | signal fcfc | snr 00b9 | ber 00000898 | unc 00000000 | FE_HAS_LOCK
>
> 'status 01' happened when running 'tzap MTV'.
> I have discovered this behaviour while watching tv with
> both vlc and kaffeine: when one of the two application are
> opened or closed, the image is garbled for about 1 seconds.
> Any feedback are welcome.

Same problem with 2.6.32
However, only the adapter 1 is affected by the adapter 0
initialize. Just to be clear: adapter 1 lose the FE_HAS_LOCK
when adapter 0 is tzapped and _not_ the viceversa, has I have
previously mistakenly reported.

I'm available for any kind of tests.
Any response are welcome.
TIA
 		 	   		  
_________________________________________________________________
Windows Live: Friends get your Flickr, Yelp, and Digg updates when they e-mail you.
http://www.microsoft.com/middleeast/windows/windowslive/see-it-in-action/social-network-basics.aspx?ocid=PID23461::T:WLMTAGL:ON:WL:en-xm:SI_SB_3:092010