Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB92VdON020759
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 21:31:39 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB92Uw3L011653
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 21:30:59 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1025613fga.7
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 18:30:58 -0800 (PST)
Message-ID: <30353c3d0812081403p11f1fcaam1b15a2650f05bcdf@mail.gmail.com>
Date: Mon, 8 Dec 2008 17:03:22 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <1228752855.1809.93.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228752855.1809.93.camel@tux.localhost>
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

This patch looks good, but I think it should remove the now unused
user member of the amradio struct as well.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
