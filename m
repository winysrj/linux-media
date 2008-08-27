Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R307BY009345
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 23:00:07 -0400
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R2xtmj010842
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 22:59:55 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1153538yxl.81
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 19:59:55 -0700 (PDT)
Message-ID: <48B4C328.2040502@gmail.com>
Date: Tue, 26 Aug 2008 22:59:52 -0400
From: Robert William Fuller <hydrologiccycle@gmail.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
References: <200808251445.22005.jdelvare@suse.de>	<1219711251.2796.47.camel@morgan.walls.org>	<20080826232913.GA2145@daniel.bse>
	<Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

Trent Piepho wrote:
> On Wed, 27 Aug 2008, Daniel [iso-8859-1] Gl�ckner wrote:
>> On Mon, Aug 25, 2008 at 08:40:51PM -0400, Andy Walls wrote:
>>> On Mon, 2008-08-25 at 14:45 +0200, Jean Delvare wrote:

<snipped>

>> The driver fills buffers with instructions for the DMA engine, one buffer
>> for the top field and one for the bottom field. These instructions tell
>> the engine where to write a specific pixel. For interlaced video the
>> instructions for the top field write to line 0, 2, 4, ... in memory and for
>> the bottom field to line 1, 3, 5, ... .
> 
> Keep in mind that _either_ field can be transmitted first.  I.e., in some
> cases one first writes lines 1,3,5 then lines 0,2,4.  I'm not sure if bttv
> supports both field dominances or not, but I think it does.

My particular board always returns top field first on capture.  I don't 
know if that helps.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
