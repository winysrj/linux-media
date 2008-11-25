Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAP6phgM015218
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 01:51:43 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAP6pQ0l029638
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 01:51:26 -0500
Received: by wf-out-1314.google.com with SMTP id 25so2518543wfc.6
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 22:51:25 -0800 (PST)
Message-ID: <5d5443650811242251g5ddda028q9413b0ff47fc08a8@mail.gmail.com>
Date: Tue, 25 Nov 2008 12:21:25 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200811242309.37489.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811242309.37489.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review
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

Hi Hans,

On Tue, Nov 25, 2008 at 3:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> I've finally tracked down the last oops so I could make a new tree with
> all the latest changes.
>

Please send these patches to mailing list (git-send-email?) for easy
review. Also CCing LKML for wider view is also good, as we are doing
some core changes right?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
