Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:55971
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754474AbZBUXrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 18:47:52 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
Date: Sat, 21 Feb 2009 23:47:46 +0000
Cc: linux-media@vger.kernel.org
References: <200902211200.45373.hverkuil@xs4all.nl>
In-Reply-To: <200902211200.45373.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902212347.47109.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 February 2009, Hans Verkuil wrote:

> The high rate of changes and new drivers means that keeping up the
> backwards compatibility becomes an increasingly heavy burden.
>
> This leads to two questions:
>
> 1) Can we change our development model in such a way that this burden is
> reduced?

Possibly but even just spreading the burden better (and avoiding the compat 
code affecting the main tree in the case of i2c) would be a worthwhile 
change.

> 2) How far back do we want to support older kernels anyway?
>

To the point that the effort expended on the compat work is balanced by the 
benefit of more testers.

> These questions are related, since changes in the development model has
> implications for the answer to the second question.
>
>
> 1: Alternatives to the development model
> ----------------------------------------
>
> I see the following options:
>
> A) Keep our current model. This also keeps the way we do our backwards
> compatibility unchanged.
>
> B) Switch to a git tree that tracks Linus' tree closely and we drop
> backwards compatibility completely.
>
> C) Switch to the ALSA approach (http://git.alsa-project.org/).
>

Another example of this approach can be seen with the linux-wireless git tree. 
There is a description of the process at 
http://linuxwireless.org/en/users/Download#Developers

It might be a more relevant example as there are changes in 2.6.27 that make 
it difficult to support older kernels. They therefore made a decision at that 
point to restrict the automated backporting to 2.6.27 onwards and say patches 
will be accepted to the compat tree that covers 2.6.21 to 2.6.26 if a driver 
change is compatible but they must be manually flagged as being suitable 
(I've no idea how many are).

It does require one person (who isn't the main wireless maintainer) to be the 
maintainer of the compat tree.

> B: Switch to a git tree and drop compatibility completely
>
> Pros:
>
> - makes driver development and v4l-dvb maintenance very easy.
> - no compatibility issues anymore, this saves a lot of time.
> - ability to change kernel code outside the driver/media part.
> - received patches against the latest git tree are easy to apply.
>

Ensures that driver changes get tested in the kernel they will be released in 
so there is less chance of a change elsewhere breaking your change. Also 
means more people are testing pre release kernels so might have stopped the 
USB bug in 2.6.28 making it to the released kernel.

> Cons:
>
> - no compatibility means that the initial testbase will be reduced
> substantially since it will be too difficult for many users to install the
> bleeding-edge kernel. So real feedback won't come in until the code is
> released as part of the main distros kernels.
> - the same is true for ourselves: we need to continuously upgrade our
> kernel, which is not always an option.
>

It also means that a git pull can result in a long long rebuild if the 
upstream has just pulled a load of changes to other subsystems.

>
> 2 How many kernels to support?
> ------------------------------

> Keeping support for older kernels should come with an expiry date as at
> some point in time the effort involved outweighs the benefits.

I think the outweighs the benefits point is critical here and indicates what 
the break point should be.

>
> Oldest supported Ubuntu kernel is 2.6.22 (7.10):
> https://wiki.ubuntu.com/Releases. End of life for this one will be in April
> 2009, after that the oldest kernel for Ubuntu will be 2.6.27 (8.10).
>
You missed 8.04 which EOLs in April 2011 for Desktop use and uses 2.6.24


> In my view these criteria strike a good balance between supporting our
> users so we can good test coverage, and limiting the effort involved in
> supporting the compatibility code. And they are also based on simple facts:
> whenever the oldest regularly supported kernel changes, we can go in and
> remove some of the compat code. No need for discussions, the rules are
> clear and consistent.

I don't think anyone will (or need) actively track theses dates unless the 
code is causing them a headache but the rule is still a useful guide - if the 
compat code is causing you a problem and the 3 most popular distros have 
EOLed the relevant kernel it can be dropped without discussion by whoever 
administers the compat repository, otherwise it should be discussed on the ML 
first.

The only question then would be how to choose the 3. I don't think 1 and 2 are 
in much dispute but I suspect OpenSUSE is slugging it out for 3rd place with 
Debian.

>
> And luckily, since the oldest kernel currently in regular use is 2.6.22
> that makes a very good argument for dropping the i2c compatibility mess.
>

Unfortunately this all omits one important point, are there any key developers 
for whom dropping support for old kernels will cause them a problem which 
could reduce their productivity.  Mauro has stated that it would cause him a 
problem but I can't tell how big a problem it would really be.

Adam
