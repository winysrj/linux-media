Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49662 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaKKSQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 13:16:35 -0500
Received: by mail-vc0-f174.google.com with SMTP id la4so1455388vcb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Nov 2014 10:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54624FF1.2060102@xs4all.nl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<54624FF1.2060102@xs4all.nl>
Date: Tue, 11 Nov 2014 20:16:33 +0200
Message-ID: <CAM_ZknWrub8adtrvTfBGrY6zHv1EGsRr-madZMdB-TqMoMrRDg@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 11, 2014 at 8:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I would first try to exclude hardware issues: since you say it is always
> the same card, try either replacing it or swapping it with another solo
> card and see if the problem follows the card or not. If it does, then it
> is likely a hardware problem. If it doesn't, then it suggests a race
> condition in the interrupt handling somewhere.

Thanks for reply, Hans.
Surely valid idea. I will ask for this, but it is out of my physical reach.
If you have any suspects about driver code, please let me know.

-- 
Bluecherry developer.
