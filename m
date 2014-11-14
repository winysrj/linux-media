Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45420 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaKNH3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 02:29:47 -0500
Received: by mail-vc0-f175.google.com with SMTP id hy10so561549vcb.34
        for <linux-media@vger.kernel.org>; Thu, 13 Nov 2014 23:29:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM_ZknWrub8adtrvTfBGrY6zHv1EGsRr-madZMdB-TqMoMrRDg@mail.gmail.com>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<54624FF1.2060102@xs4all.nl>
	<CAM_ZknWrub8adtrvTfBGrY6zHv1EGsRr-madZMdB-TqMoMrRDg@mail.gmail.com>
Date: Fri, 14 Nov 2014 11:29:45 +0400
Message-ID: <CAM_ZknUcBNbTCzK=xzW-HG_CMKBbG=uitD2089QVgx8QR5CVSw@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 11, 2014 at 10:16 PM, Andrey Utkin
<andrey.utkin@corp.bluecherry.net> wrote:
> On Tue, Nov 11, 2014 at 8:05 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> I would first try to exclude hardware issues: since you say it is always
>> the same card, try either replacing it or swapping it with another solo
>> card and see if the problem follows the card or not. If it does, then it
>> is likely a hardware problem. If it doesn't, then it suggests a race
>> condition in the interrupt handling somewhere.
>
> Thanks for reply, Hans.
> Surely valid idea. I will ask for this, but it is out of my physical reach.
> If you have any suspects about driver code, please let me know.

(We haven't tested the replacement yet.)
To the big surprise, it turned out that FPS=2 on the channels works
unstable, but FPS=30 works stable.

-- 
Bluecherry developer.
