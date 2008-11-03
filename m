Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3ILuTu009455
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 13:21:56 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA3ILgnT012689
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 13:21:43 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2471680fga.7
	for <video4linux-list@redhat.com>; Mon, 03 Nov 2008 10:21:21 -0800 (PST)
Message-ID: <30353c3d0811031021m28645ccbq69a53a35dbbd8e4@mail.gmail.com>
Date: Mon, 3 Nov 2008 13:21:21 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alexey Klimov" <klimov.linux@gmail.com>
In-Reply-To: <1225734693.20921.15.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
	<30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
	<1225728173.20921.6.camel@tux.localhost>
	<30353c3d0811030819k4e6610d6u4188b940a40b02f5@mail.gmail.com>
	<1225733048.20921.11.camel@tux.localhost>
	<30353c3d0811030936n744a55b2hb33b9300a4030106@mail.gmail.com>
	<1225734693.20921.15.camel@tux.localhost>
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

On Mon, Nov 3, 2008 at 12:51 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> And this version ? :)
> Maybe it's good idea to remove KBUILD_MODNAME in pr_info and place
> MR800_DRIVER_NAME there ?
>

It's your choice. I'm ok with the use of KBUILD_MODNAME there as it's
within a module_init function. If you use the MR800_DRIVER_NAME macro,
I'd prefer to see another macro definition similar to the other one,
something like amradio_err which expands to calling
pr_err(MR800_DRIVER_NAME... for consistency. Let me know if you want
me to ack this one, otherwise send a revised patch.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
