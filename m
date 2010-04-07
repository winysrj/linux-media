Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:65064 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab0DGSfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Apr 2010 14:35:13 -0400
Message-ID: <4BBCD05A.2060305@vorgon.com>
Date: Wed, 07 Apr 2010 11:35:06 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Possible bug with FusionHDTV7 Dual Express
References: <4BBA462E.5060203@vorgon.com>
In-Reply-To: <4BBA462E.5060203@vorgon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ran fin without problems for several days. Changed setting to "-D 0 -D 1 
-D 2" So it would use all 3 tuners (default) and left it on the 3rd 
tuner. Next morning first tuner was down. Today I'm trying it with "-D 0 
-D 2" So it uses the first tuner of the dual and the 3rd tuner (second 
card). Leaving it set with vdr on the 3rd tuner.

On 4/5/2010 1:21 PM, Timothy D. Lenz wrote:
> For some time I have been having problems with VDR seemingly loosing
> control over one of the two tuners. It seems to be related to the
> atscepg plugin. It happened quicker after VDR had timer recorded a show.
> Removing the plugin seemed to stop it but also get no epg data. basicly,
> which ever tuner vdr was displaying from, the other tuner would seem to
> stop working. You get no signal. But only vdr needed to be restarted to
> get the tuner back. One tuner always seemed to go down within 24hrs when
> using the plugin. It seems to be related to when the plugin used a free
> tuner to scan epg.
>
> I put a second card in, an HVR-1800 which became the 3rd dvb device
> according to vdr. Same thing kept happening. Always the first or second
> tuner since no mater which vdr was using, it would always be one of
> those that was left free. I started vdr with "-D 1 -D 2" to force vdr to
> only use 1 tuner of the dual and the second card. I also use femon to
> make sure vdr is using dvb1 after changing channels so that the plugin
> uses the second card for scanning.
>
> It has been running for a couple of days and done recordings without
> loosing a tuner. Since forcing it to use only one tuner of the dual
> seems to have stopped the problem, it is starting to look like a driver
> problem with the fusion card. Today I used femon to put vdr on dvb2 so
> that the plugin uses the fusion to scan epg. In a couple days if the
> problem still doesn't show, I may swap slot positions of the two cards
> so vdr use the 1800 without forcing by blocking a tuner.
>
> The plugin Author has also been looking into this, but he only recently
> got a second tuner card working.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
