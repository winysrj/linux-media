Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m220PD3I028391
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 19:25:13 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m220Ofe3012649
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 19:24:42 -0500
Date: Sun, 2 Mar 2008 01:24:22 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michael Williamson <michael_h_williamson@yahoo.com>
Message-ID: <20080302002422.GB1691@daniel.bse>
References: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
	<527852.36382.qm@web65508.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527852.36382.qm@web65508.mail.ac4.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: question
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

On Sat, Mar 01, 2008 at 02:49:42PM -0800, Michael Williamson wrote:
> With CX100 frame grabbers, it is possible to poll the
> even/odd video field bit through the ISA bus. 
> This is useful to have for cameras with electronic
> shutters to make long exposures. Is it possible to do
> with v4l2/bt848 PCI devices?

This information is available in the DSTATUS and INT_STAT register of the
bt848 but it is not exposed to userspace by the driver.

You can capture fields seperately to be informed of field changes.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
