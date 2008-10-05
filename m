Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95BvhWD019600
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:57:43 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95BvOcG002480
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:57:31 -0400
Received: by yx-out-2324.google.com with SMTP id 31so355615yxl.81
	for <video4linux-list@redhat.com>; Sun, 05 Oct 2008 04:57:24 -0700 (PDT)
Message-ID: <48E8ABA0.8070305@gmail.com>
Date: Sun, 05 Oct 2008 07:57:20 -0400
From: Robert William Fuller <hydrologiccycle@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200810031633.43418.hverkuil@xs4all.nl>	<5A47E75E594F054BAF48C5E4FC4B92AB02D603E9FB@dbde02.ent.ti.com>
	<20081005081931.1dfdd7b4@pedra.chehab.org>
In-Reply-To: <20081005081931.1dfdd7b4@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Mauro Carvalho Chehab wrote:
> On Fri, 3 Oct 2008 20:10:36 +0530
> "Shah, Hardik" <hardik.shah@ti.com> wrote:
>>> 3) Some of the lines are broken up rather badly probably to respect the
>>> 80 column maximum. Note that the 80 column maximum is a recommendation,
>>> and that readability is more important. So IMHO it's better to have a
>>> slightly longer line and break it up at a more logical place. However,
>>> switching to video_ioctl2 will automatically reduce the indentation, so
>>> this might not be that much of an issue anymore.
>> [Shah, Hardik] 80 column was implemented to make the checkpatch pass.  Point noted and will take care of this.
> 
> The 80 column rule isn't there for nothing.

The 80 column rule is retarded.  None of this code needs to fit on punch 
cards, nor is it COBOL.  There are legitimate reasons to have lines 
longer than 80 columns.  No matter how simple a program is, it is likely 
to have an expression that is longer than 80 characters.  Most people's 
displays are wider than 80 columns these days.  Vertical real estate is 
at a greater premium than horizontal real estate these days with wider 
aspect ratio monitors, which better approximate the human field of 
vision.  Why make people scan more than one line for a single expression?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
