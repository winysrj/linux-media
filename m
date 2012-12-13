Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55384 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2LMSQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 13:16:19 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so6748372qaq.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 10:16:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CA16EB.7060201@googlemail.com>
References: <1354980692-3791-1-git-send-email-fschaefer.oss@googlemail.com>
	<CAGoCfiw1wN+KgvNLqDSmbz5AwswPT9K48XOM4RnfKvHkmmR59g@mail.gmail.com>
	<50CA16EB.7060201@googlemail.com>
Date: Thu, 13 Dec 2012 13:16:18 -0500
Message-ID: <CAGoCfixtaQ4Jj2dW7XaAzcqEBTDj3xRnO_iCP=kOnhaxYwO2rw@mail.gmail.com>
Subject: Re: [PATCH 0/9] em28xx: refactor the frame data processing code
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 13, 2012 at 12:56 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Am 13.12.2012 18:36, schrieb Devin Heitmueller:
>> On Sat, Dec 8, 2012 at 10:31 AM, Frank Schäfer
>> <fschaefer.oss@googlemail.com> wrote:
>>> This patch series refactors the frame data processing code in em28xx-video.c to
>>> - reduce code duplication
>>> - fix a bug in vbi data processing
>>> - prepare for adding em25xx/em276x frame data processing support
>>> - clean up the code and make it easier to understand
>> Hi Frank,
>>
>> Do you have these patches in a git tree somewhere that I can do a git
>> pull from?  If not then that's fine - I'll just save off the patches
>> and apply them by hand.
>
> No, I have no public git tree.
>
>> I've basically got your patches, fixes Hans did for v4l2 compliance,
>> and I've got a tree that converts the driver to videobuf2 (which
>> obviously heavily conflicts with the URB handler cleanup you did).
>> Plan is to suck them all into a single tree, deal with the merge
>> issues, then issue a pull request to Mauro.
>
> Ahhh, videobuf2 !
> Good to know, because I've put this on my TODO list... ;)

It's harder than it looks.  There are currently no other devices
ported to vb2 which have VBI and/or radio devices.  Hence I have to
refactor the locking a bit (since the URB callback feeds two different
VB2 queues).  In other words, there's no other driver to look at as a
model and copy the business logic from.

> Yes, there will likely be heavy merge conflicts...
> In which tree are the videobuf2 patches ?

It's in a private tree right now, and it doesn't support VBI
currently.  Once I've setup a public tree with yours and Hans changes,
I'll start merging in my changes.

Obviously it would be great for you to test with your webcam and make
sure I didn't break anything along the way.

I've also got changes to support V4L2_FIELD_SEQ_TB, which is needed in
order to take the output and feed to certain hardware deinterlacers.
In reality this is pretty much just a matter of treating the video
data as progressive but changing the field type indicator.

I'm generally pretty easy to find in #linuxtv or #v4l if you want to
discuss further.

Cheers,

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
