Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40116 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3JVKCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Oct 2013 06:02:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Guest <info@are.ma>, linux-media <linux-media@vger.kernel.org>,
	=?utf-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4=?= <knightrider@are.ma>,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	peter.senna@gmail.com
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/ISDB-T) cards.
Date: Tue, 22 Oct 2013 12:02:42 +0200
Message-ID: <8146221.SsOktkoBmV@avalon>
In-Reply-To: <CAOcJUbxcSZnxNieA3sv-1QTHxORXTPhzOvNgxtFcDGh0FVOWCQ@mail.gmail.com>
References: <1382429139-19346-1-git-send-email-guest@puma.are.ma> <CAOcJUbxcSZnxNieA3sv-1QTHxORXTPhzOvNgxtFcDGh0FVOWCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 22 October 2013 05:20:51 Michael Krufky wrote:
> On Tue, Oct 22, 2013 at 4:05 AM, Guest <info@are.ma> wrote:
> > From: Буди Романто <knightrider@are.ma>
> >
> > DKMS support is removed in this patch. The full package is still available
> > at https://github.com/knight-rider/ptx/tree/master/pt3_dvb
> >
> >       Signed-off-by: Budi Rachmanto <knightrider @ are.ma>
>
> Budi,
> 
> Is there any reason why you send this from a 'guest' email account
> other than that from which you signed-off from?  It's not a problem,
> I'm just wondering.  Provided that you will be able to receive replies
> to both emails, this is fine.
> 
> Please make sure that when you submit a patch, the patch description
> describes what the patch is doing.  Perhaps your earlier patch sent in
> private may have had a description, but the folks reading the mailing
> list haven't seen that.
> 
> Please remove all typedef's - this is not allowed.  For example, if
> you are using a struct dvb_frontend, then use a struct dvb_frontend -
> do not obfuscate these types with typedefs.  You may declare enums,
> but do not use typedefs.
> 
> Please move all code out of header files and into c files - header
> files can be used for function prototypes, struct definitions and any
> #define's but anything that results is code generation such as
> MODULE_AUTHOR or any function definitions should be moved into the
> appropriate c file.  If you need to access these objects from multiple
> c files then you can put the reference in the header but the actual
> code must be inside c files.
> 
> Do not use UPPERCASE unless there is a *very* good reason, such as a
> #define, macro or constants defined within an enum.
> 
> When touching files that already exist, do not add new items in the
> middle of an existing list - always append to the end as appropriate -
> this applies to Kconfig and Makefile as well.

I would disagree with this. I tend to group drivers into categories, and then 
sort them alphabetically. If that's not done for DVB yet then adding the 
driver at the end of the list makes sense.

> Do not use // style comments in the kernel.  In the kernel, use /*
> comments styled this way */
> 
> Do not use __u8 or __u32 and so on - just use u8 and u32 etc.

I'd add two items to this list:

- getting rid of the #if 0 and #if 1

- fixing the checkpatch.pl errors and warnings (it's fine to ignore some 
warnings when it makes sense, but most of them should be fixed)

> I didn't have a chance to fully review this driver yet, but I will
> take another pass at it on your next submission.
> 
> Thanks for your hard work - I look forward to your next patch.

-- 
Regards,

Laurent Pinchart

