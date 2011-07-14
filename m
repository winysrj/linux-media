Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1GNBSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 21:18:55 -0400
Received: by eyx24 with SMTP id 24so2317475eyx.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2011 18:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E35E4272@dbde02.ent.ti.com>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com>
	<19F8576C6E063C45BE387C64729E739404E35E4272@dbde02.ent.ti.com>
Date: Wed, 13 Jul 2011 20:18:52 -0500
Message-ID: <CAD=GYpZHbZSLSwuEFX7UWrb5_S0mrrVB1v_+=L-QN8Cs-f9Ndg@mail.gmail.com>
Subject: Re: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
 support for BeagleBoard
From: Joel A Fernandes <agnel.joel@gmail.com>
To: beagleboard@googlegroups.com
Cc: "Kridner, Jason" <jdk@ti.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Kooi, Koen" <k-kooi@ti.com>, "Prakash, Punya" <pprakash@ti.com>,
	"Maupin, Chase" <chase.maupin@ti.com>,
	"Kipisz, Steven" <s-kipisz2@ti.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

Thanks for your email.

On Wed, Jul 13, 2011 at 2:55 PM, Hiremath, Vaibhav <hvaibhav@ti.com> wrote:
>
>> -----Original Message-----
>> From: beagleboard@googlegroups.com [mailto:beagleboard@googlegroups.com]
>> On Behalf Of Joel A Fernandes
>> Sent: Wednesday, July 13, 2011 11:52 PM
>> To: beagleboard@googlegroups.com
>> Cc: Joel A Fernandes; Kridner, Jason; Javier Martin;
>> laurent.pinchart@ideasonboard.com; linux-media@vger.kernel.org; Kooi,
>> Koen; Prakash, Punya; Maupin, Chase; Kipisz, Steven; Aguirre, Sergio
>> Subject: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
>> support for BeagleBoard
>>
>> * Adds support for mt9v113 sensor by borrowing heavily from PSP 2.6.37
>> kernel patches
>> * Adapted to changes in v4l2 framework and ISP driver
>>
>> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
>> ---
>> This patch will apply against the 2.6.39 kernel built from the OE-
>> development tree (Which is essentially
>> the v2.6.39 from the main tree with OE patches for BeagleBoard support and
>> a few other features)
>>
>> If you have the Leapord imaging camera board with this particular sensor,
>> I would apprecite it if anyone could
>> try this patch out and provide any feedback/test results.
>>
>> To get the complete tree which works on a BeagleBoard-xM with all the OE
>> patches and this patch,
>> you can clone: https://github.com/joelagnel/linux-omap-2.6/tree/oedev-
>> 2.6.39-mt9v113
>>
>> It will compile and work on a BeagleBoard-xM with the defconfig at:
>> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux/linu
>> x-omap-2.6.39/beagleboard/defconfig
>>
>> Also you will need to apply my media-ctl patch (or clone the tree) to
>> setup the formats:
>> https://github.com/joelagnel/media-
>> ctl/commit/cdf24d1249ac1ff3cd6f70ad80c3b76ac28ba0d5
>>
>> Binaries for quick testing on a BeagleBoard-xM:
>> U-boot: http://utdallas.edu/~joel.fernandes/u-boot.bin
>> U-boot: http://utdallas.edu/~joel.fernandes/MLO
>> uEnv.txt: http://utdallas.edu/~joel.fernandes/uEnv.txt
>> media-ctl: http://utdallas.edu/~joel.fernandes/media-ctl
>> kernel: http://utdallas.edu/~joel.fernandes/uImage
>>
>> media-ctl/yavta commands you could use to get it to show a picture can be
>> found at:
>> http://utdallas.edu/~joel.fernandes/stream.sh
>>
>> Note:
>> The BeagleBoard camera board file in this patch replaces the old one, so
>> this will take away support for the 5M
>> sensor (mt9p031), I hope this can be forgiven considering this is an
>> RFC :). I am working on a common board file
>> that will work for both sensors.
>>
>  [Hiremath, Vaibhav] Joel,
>
> I am bit surprised by this patch submission, first of all, the patch has been submitted without my knowledge. And I was not aware that you are targeting linux-media for this code-snippet.
>
> This code needs lot of cleanup and changes to get to the level where we can submit it to the linux-media, and I think I clearly mentioned about known issues with this patch/driver in the commit itself. Please refer to the below commit -
>
> http://arago-project.org/git/projects/?p=linux-omap3.git;a=commitdiff;h=c6174e0658b9aaa8f7a3ec9fe562619084d34f59
>
> I agree that we had some internal discussion on this and I was under assumption that this effort was only towards beagle openembedded and not for linux-media.
>
[Joel]

I'm sorry, actually the intent of the RFC was to get immediate VGA
camera support to Beagle users and some testing with our kernel. The
other intention was to help your team with the differences in what has
changed across the kernels as a reference so that you reuse some of
the work. Certainly I was not going to claim authorship or make the
final submission.

About Signed-off-by lines (if that's what you refer to about
authorship), I intentionally didn't include it in my temporary git
tree as I wanted to make sure if I could use it without permission. My
intention was to rebase and include the relevant SOB lines after I got
clarification on this. Could you suggest a general rule about SOB
lines and whether these can be used without permission when you
reuse/adapt a patch?

I hoped that the words "borrowed from PSP" in the commit summary, the
relevant links to the commits in your tree in the commit summaries and
the retaining of copyright information in the code made it clear that
I was not the original author.

I understand that it is a bit frustrating to see someone take your
code when its not yet complete, anyway I hope my commits help in some
way. Atleast there might be a few people who test your code on the
Beagle and give your team some valuable feedback.

Thanks,
Joel
