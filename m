Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42046 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829AbbBMQOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 11:14:44 -0500
Message-ID: <1423844081.2887.6.camel@xs4all.nl>
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Raimonds Cicans <ray@apollo.lv>, linux-media@vger.kernel.org
Date: Fri, 13 Feb 2015 17:14:41 +0100
In-Reply-To: <54DDC00D.209@xs4all.nl>
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
			 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
			 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>
		 <1423065972.2650.1.camel@xs4all.nl> <54D24685.1000708@xs4all.nl>
	 <1423070484.2650.3.camel@xs4all.nl> <54DDC00D.209@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, 2015-02-13 at 10:12 +0100, Hans Verkuil wrote:
> Hi Jurgen,
> 
> On 02/04/2015 06:21 PM, Jurgen Kramer wrote:
> > On Wed, 2015-02-04 at 17:19 +0100, Hans Verkuil wrote:
> >> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
> >>> Hi Hans,
> >>>
> >>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
> >>>> Raimonds and Jurgen,
> >>>>
> >>>> Can you both test with the following patch applied to the driver:
> >>>
> >>> Unfortunately the mpeg error is not (completely) gone:
> >>
> >> OK, I suspected that might be the case. Is the UNBALANCED warning
> >> gone with my vb2 patch?
> 
> >> When you see this risc error, does anything
> >> break (broken up video) or crash, or does it just keep on streaming?
> 
> Can you comment on this question?
I still get the risc errors at regular intervals. I am not sure what the real impact is. 
I do get the occasional failed recording (dreaded 0 byte recoderings).
> > 
> > The UNBALANCED warnings have not reappeared (so far).
> 
> And they are still gone? If that's the case, then I'll merge the patch
> fixing this for 3.20.
No, these are gone.
> 
> With respect to the risc error: the only reason I can think of is that it
> is a race condition when the risc program is updated. I'll see if I can
> spend some time on this today or on Monday. Can you give me an indication
> how often you see this risc error message?

dmesg |grep "risc op code error"
[ 1267.999719] cx23885[1]: mpeg risc op code error
[17830.312766] cx23885[2]: mpeg risc op code error
[37820.312372] cx23885[2]: mpeg risc op code error
[48973.897721] cx23885[2]: mpeg risc op code error
[126673.151447] cx23885[0]: mpeg risc op code error
[208262.607584] cx23885[2]: mpeg risc op code error
[212564.803499] cx23885[2]: mpeg risc op code error
[288834.700570] cx23885[1]: mpeg risc op code error
[298753.789105] cx23885[2]: mpeg risc op code error
[341900.746719] cx23885[2]: mpeg risc op code error
[346513.849946] cx23885[1]: mpeg risc op code error
[359267.169552] cx23885[2]: mpeg risc op code error
[370728.293458] cx23885[1]: mpeg risc op code error
[423626.314834] cx23885[1]: mpeg risc op code error
uptime:
 17:14:03 up 4 days, 22:22,  2 users,  load average: 0.19, 0.39, 0.34


Best regards,
Jurgen

