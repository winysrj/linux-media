Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB91gefr026907
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 20:42:41 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.189])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB91gY59012640
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 20:42:34 -0500
Received: by nf-out-0910.google.com with SMTP id d3so701743nfc.21
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 17:42:34 -0800 (PST)
Message-ID: <208cbae30812081410i37ad8da8ue43f907ad9a54b@mail.gmail.com>
Date: Tue, 9 Dec 2008 01:10:53 +0300
From: "Alexey Klimov" <klimov.linux@gmail.com>
To: "David Ellingsworth" <david@identd.dyndns.org>
In-Reply-To: <30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228752855.1809.93.camel@tux.localhost>
	<30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] radio-mr800: correct unplug, fix to previous patch
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

On Tue, Dec 9, 2008 at 1:03 AM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> This patch looks good, but I think it should remove the now unused
> user member of the amradio struct as well.

Should i remake this patch now ? Or make one more patch ?

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
