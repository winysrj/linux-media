Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 4 Nov 2008 19:55:40 +0100
References: <200811032103.36711.laurent.pinchart@skynet.be>
	<200811032147.04546.laurent.pinchart@skynet.be>
	<200811040709.29024.hverkuil@xs4all.nl>
In-Reply-To: <200811040709.29024.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811041955.40763.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, mchehab@redhat.com
Subject: Re: [PATCH 2/2] v4l2: Add camera privacy control.
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

On Tuesday 04 November 2008, Hans Verkuil wrote:
> Hi Laurent,
>
> Can you also patch v4l2-common.c to add support for this new control?

Sorry, I forgot about that.

> Actually, it would be great if the other missing controls (e.g. FOCUS
> controls) are also added.

I'll prepare a patch and submit it along with zoom support.

Mauro, if you haven't picked the camera privacy control patch yet, please 
ignore it. I'll resubmit with the missing changes to v4l2-common.c.

Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
