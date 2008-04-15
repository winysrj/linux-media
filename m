Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3F084de030143
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 20:08:04 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3F07fPd005643
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 20:07:42 -0400
Received: by rv-out-0506.google.com with SMTP id b17so781023rvf.51
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 17:07:41 -0700 (PDT)
Message-ID: <d9def9db0804141707k49d67d7fq5e5e91d648e3e108@mail.gmail.com>
Date: Tue, 15 Apr 2008 02:07:41 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <4803DEF0.8090003@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <478CA9C0.6060004@egrandrapids.net> <478CD0A5.1000700@linuxtv.org>
	<48037622.2040506@gmail.com> <4803DEF0.8090003@linuxtv.org>
Cc: Scott Z <zuidemsr@gmail.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Pinnacle HD 801e
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

On 4/15/08, Steven Toth <stoth@linuxtv.org> wrote:
> Scott Z wrote:
> > Steve,
> >
> > I saw you were working on a driver for the HVR950Q.  I recently went out
> > to purchase a Pinnacle 800e, and it turned out to be an 801e.  I was
> > thinking the 801e was a copy of the HVR950Q since I thought the 800e was
> > a copy of the HVR950.
> >
> > I tried to use the HVR950Q repository that you have.  I just simply
> > changed the device ID to make a 801e look like a HVR950Q.  This didn't
> > work.  I wondered this was too simple of an approach.  Also, if there is
> > an advice you can give on things I could try, that would be great.  I
> > have a fairly good programming background, but limited driver support.
>
> Hey Scott,
>
> Bad choice, 950q is a good stick.
>
> I've copied the v4l mailing list on this reply, as other may be able to
> help.
>
> Have you opened the device? Do you know what parts it contains? Do you
> have a list of the windows driver files - perhaps we can partly
> determine form this.
>

no need to open the stick.

 DIBcom 0700C-XCCXa-G
 USB 2.0 D3LTK.1
 0804-0100-C
 -----------------
 SAMSUNG
 S5H1411X01-Y0
 NOTKRSUI H0801
 -----------------
 XCeive
 XC5000AQ
 BK66326.1
 0802MYE3
 -----------------
 Cirrus
 5340CZZ
 0748
 -----------------
 CONEXANT
 CX25843-24Z
 71035657
 0742 KOREA
 -----------------

http://thread.gmane.org/gmane.linux.drivers.dvb/40970

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
