Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m971A1ss015537
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 21:10:01 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9719oRV026189
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 21:09:50 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2368079fga.7
	for <video4linux-list@redhat.com>; Mon, 06 Oct 2008 18:09:50 -0700 (PDT)
Message-ID: <d9def9db0810061809o71280e4el85452c63efa2324d@mail.gmail.com>
Date: Tue, 7 Oct 2008 03:09:50 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Dan Taylor" <dtaylor@startrac.com>
In-Reply-To: <1822849CB0478545ADCFB217EF4A3405026175AE@sedah.startrac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1822849CB0478545ADCFB217EF4A3405026175AE@sedah.startrac.com>
Cc: video4linux-list@redhat.com
Subject: Re: raw transport stream access?
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

2008/10/7 Dan Taylor <dtaylor@startrac.com>:
> I'm trying to debug performance issues in our system.  There seem to be
> issues with both high data rate streams, and with our post-processing.
>
>
>
> I would like to be able to read an entire transport stream (all PIDs,
> without specifically identifying them) from the tuner and dump it to,
> for example, /dev/null, or to a file.  This lets me work on the high
> data rate issue separately from the post-processing, and I can use a
> captured stream to work on the post-processing.
>
>
>
> All of the examples that I have been able to find, so far, set up a
> filter for each PID, then either capture the individual PID streams or
> remultiplex them into a new TS.
>
>
>
> I have code that tunes the frontend correctly.
>
>
>
> Can anyone point me to a simple "now that the FE is tuned, grab the
> entire stream" example?
>

dvbstream -o 8192

is probably what you're looking for.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
