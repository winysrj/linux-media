Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95JGJVJ013692
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 15:16:19 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95JG5dT010957
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 15:16:05 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810051738.m95HcnWJ070581@smtp-vbr3.xs4all.nl>
References: <200810051738.m95HcnWJ070581@smtp-vbr3.xs4all.nl>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 15:15:27 -0400
Message-Id: <1223234127.2794.27.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Q: standard method to output statistics from a driver? (Re:
	[v4l-dvb-maintainer] [cron job] ERRORS: armv5 armv5-ixp i686 m32r
	mips powerpc64 x86_64 v4l-dvb build)
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

On Sun, 2008-10-05 at 19:38 +0200, Hans Verkuil wrote:

> Results of the daily build of v4l-dvb:
> 
> date:        Sun Oct  5 19:00:08 CEST 2008
> path:        http://www.linuxtv.org/hg/v4l-dvb
> changeset:   9113:979d14edeb2e
> gcc version: gcc (GCC) 4.3.1
> hardware:    x86_64
> host os:     2.6.26
> 

> sparse (linux-2.6.26): ERRORS
> sparse (linux-2.6.27-rc8): ERRORS
> 
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Sunday.log

To make the sparse build cx18 warnings go away, add "__iomem" to the
third argument of these functions in cx18-io.h:

void cx18_log_write_retries(struct cx18 *cx, int i, const void *addr)
void cx18_log_read_retries(struct cx18 *cx, int i, const void *addr)

They are just statistics gathering functions.


But that leads me to this question:

Is there a preferred or standard way to present gathered statistics to a
user-space for v4l-dvb drivers?

For example, I recall (circa 1997) the g_NCR5380 driver built /proc
entries where one could view statistics for that SCSI driver.

Right now, I have the cx18 module output collected statistics when the
"debug" module param has "info" set and a) the module is unloaded (done
for when init fails and I can't get a device node, but need statistics)
and b) when using v4l2-ctl --log-status.



Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
