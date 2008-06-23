Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NGl5fL026092
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 12:47:05 -0400
Received: from mail8.sea5.speakeasy.net (mail8.sea5.speakeasy.net
	[69.17.117.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NGkr7B000516
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 12:46:53 -0400
Date: Mon, 23 Jun 2008 09:46:47 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080623150734.GF18397@plankton.ifup.org>
Message-ID: <Pine.LNX.4.58.0806230938450.535@shell2.speakeasy.net>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<20080623150734.GF18397@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
 attribute for	persistent video4linux device nodes
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

On Mon, 23 Jun 2008, Brandon Philips wrote:
> On 13:34 Sun 22 Jun 2008, Hans Verkuil wrote:
> > Or if that's not possible for some reason, at least avoid the
> > expensive struct allocation and simply use a bitarray allocated on the
> > stack (max 256 devices = 32 bytes)?
>
> Using ffz and set_bit would be an option (since bitfields can't be used
> on arrays) but I don't think the savings would be worth the effort since
> we would need to use division and an array if VIDEO_NUM_DEVICES grows
> past 256.

unsigned long used[VIDEO_NUM_DEVICES / (sizeof(used[0])*8)];

for_each_device {
    set_bit(index, used);
}

empty = find_first_zero_bit(used, VIDEO_NUM_DEVICES);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
