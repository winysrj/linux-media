Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA1HtnGT007122
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 13:55:49 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA1Htboo022663
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 13:55:38 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1534289fga.7
	for <video4linux-list@redhat.com>; Sat, 01 Nov 2008 10:55:37 -0700 (PDT)
Message-ID: <d9def9db0811011055x7d75b705oa1facb09834bd1c5@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:55:36 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <84144f020811010929q579bebd7p8760d34631df2fd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	<412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	<84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
	<412bdbff0811010919v3b336939qf94df1162ecbbb28@mail.gmail.com>
	<84144f020811010929q579bebd7p8760d34631df2fd4@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>, Greg KH <greg@kroah.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	mchehab@infradead.org, em28xx <em28xx@mcentral.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
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

On Sat, Nov 1, 2008 at 5:29 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Sat, Nov 1, 2008 at 6:19 PM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> The reality is that from a technical standpoint I really want Markus
>> to be the maintainer.  He knows more about the devices than anyone,
>> works for the vendor, and has access to all the datasheets.  That
>> said, I don't want a situation where he is the *only* one who can do
>> work on the codebase because it is poorly commented and structured in
>> a way where only he can understand why it works the way it does.
>> Also, I believe certain design decisions should be made as a result of
>> consensus with the other maintainers, taking into consideration
>> consistency across drivers.
>
> I can understand that you want him to be the maintainer. But so far he
> hasn't really shown to be interested in doing that. It's just bit sad
> that the we don't have a proper driver given that the code exists and
> that there's a person who's willing to do the work to get it merged...
>

There's alot discussion and I haven't followed it yet although, the
best way to go
seen from my side is to take the em28xx-new code and merge the usable kernelcode
into that one (note that only ~10% of the devices in the kernel em28xx
driver are actually
tested).

I read about the License, I can say this is no issue overall, all of
the code is available under GPL,
and some of it is also under BSD license.

I need to catch up the other mails before continuing...

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
