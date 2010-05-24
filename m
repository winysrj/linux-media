Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40604 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0EXHcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 03:32:08 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L2W001JLY9FRI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 May 2010 08:32:03 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L2W001XBY9ER1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 May 2010 08:32:03 +0100 (BST)
Date: Mon, 24 May 2010 09:31:22 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Setting up a GIT repository on linuxtv.org
In-reply-to: <201005240925.57725.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Andy Walls' <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Message-id: <001101cafb13$1c1b9300$5452b900$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1274635044.2275.11.camel@localhost>
 <001001cafb0f$f6d95580$e48c0080$%osciak@samsung.com>
 <201005240925.57725.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

>Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>On Monday 24 May 2010 09:08:51 Pawel Osciak wrote:
>> >Andy Walls wrote:
>> >Hi,
>> >
>> >I'm a GIT idiot, so I need a little help on getting a properly setup
>> >repo at linuxtv.org.  Can someone tell me if this is the right
>> >procedure:
>> >
>> >$ ssh -t awalls@linuxtv.org git-menu
>> >
>> >        (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)
>> >
>> >$ git clone \
>> >
>> >	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
>> >
>> >        v4l-dvb
>>
>> If I understand correctly, you won't be working on that repository directly
>> (i.e. no working directory on the linuxtv server, only push/fetch(pull),
>> and the actual work on your local machine), you should make it a bare
>> repository by passing a --bare option to clone.
>
>There's a slight misunderstanding here. The ssh command runs the git-menu
>application on the server. It doesn't open an interactive shell. The git
>clone
>command is then run locally, where a working directory is needed.

Ah, I though the clone was executed remotely as well. Please ignore my post
then and thanks to Laurent for noticing :)

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


 


