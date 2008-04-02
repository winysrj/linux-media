Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32J0Snl032535
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 15:00:28 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32IxgBW014126
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 14:59:50 -0400
Received: by wf-out-1314.google.com with SMTP id 28so3527403wfc.6
	for <video4linux-list@redhat.com>; Wed, 02 Apr 2008 11:59:41 -0700 (PDT)
Date: Wed, 2 Apr 2008 11:56:32 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080402185632.GA21568@plankton.ifup.org>
References: <patchbomb.1206699511@localhost> <20080328160946.029009d8@gaivota>
	<20080329052559.GA4470@plankton.ifup.org>
	<20080331153555.6adca09b@gaivota>
	<20080331192618.GA21600@plankton.ifup.org>
	<20080331183136.3596bfb3@gaivota>
	<20080401031130.GA18963@plankton.ifup.org>
	<20080401174919.4bdc3c54@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401174919.4bdc3c54@gaivota>
Cc: v4l-dvb-maintainer@linuxtv.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 9] videobuf fixes
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

On 17:49 Tue 01 Apr 2008, Mauro Carvalho Chehab wrote:
> On Mon, 31 Mar 2008 20:11:30 -0700
> Brandon Philips <brandon@ifup.org> wrote:
> 
> > On 18:31 Mon 31 Mar 2008, Mauro Carvalho Chehab wrote:
> > > > > The patch is wrong. 
> Ok. Could you please update your tree with the latest patches? I think the
> better way is to merge they on v4l/dvb and ask more people to test.

Oh, I also dropped the spin_lock patches for soc/pxa/videobuf until
Guennadi has a chance to send in working patches for his driver.

 http://ifup.org/hg/v4l-dvb

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
