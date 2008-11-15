Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAF5uMGu018909
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 00:56:22 -0500
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAF5u9dK003110
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 00:56:10 -0500
Date: Fri, 14 Nov 2008 21:56:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David <david@unsolicited.net>
Message-Id: <20081114215607.dc10a235.akpm@linux-foundation.org>
In-Reply-To: <491DDD98.7090306@unsolicited.net>
References: <491DDD98.7090306@unsolicited.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Regression: USB/DVB 2.6.26.8 --> 2.6.27.6
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

(cc video4linux-list@redhat.com)

On Fri, 14 Nov 2008 20:20:40 +0000 David <david@unsolicited.net> wrote:

> I've just tried to upgrade my media server to the latest stable kernel
> and have found problems with my USB DVB  devices. With the new kernel
> I'm seeing
> 
> DVB: registering new adapter (Technotrend TT-connect S-2400)
> DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
> dvb-usb: recv bulk message failed: -110
> ttusb2: there might have been an error during control message transfer.
> (rlen = 0, was 0)
> dvb-usb: Technotrend TT-connect S-2400 successfully initialized and
> connected.
> 
> All of the registered DVB devices are now inoperable. dmesgs from both
> kernels attached. There are subtle differences in the device numbering
> as the devices were in warm state on the second kernel boot (however the
> problem is still present whether the devices are warm or cold).
> 
> Any help will be appreciated
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
