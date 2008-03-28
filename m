Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SEhGBS012967
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:43:16 -0400
Received: from MTA009E.interbusiness.it (MTA009E.interbusiness.it [88.44.62.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SEh0Ia023228
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 10:43:02 -0400
Message-ID: <47ED03EB.4070708@gmail.com>
Date: Fri, 28 Mar 2008 15:42:51 +0100
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47ECFBFC.4070708@gmail.com>
	<d9def9db0803280716j1971fb49ge58e825a8ab6229a@mail.gmail.com>
In-Reply-To: <d9def9db0803280716j1971fb49ge58e825a8ab6229a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Empia em28xx based USB video device...
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


ARGH, you are righttt ! :)
Thank you for the tip Markus, very useful.

Ok, I post some info about the device for future reference:

Brand: Digitus
Model: DA-70820
ID eb1a:2821 eMPIA Technology, Inc.
Site: http://www.digitus.info/scripts/digdetail.asp?artnr=DA-70820

Module used: em28xx
Params: card=9
( Pinnacle Dazzle DVC 90/DVC 100 )
I had few tests for now... xawtv: ok... v4l2 small test app: ok...
I dunno if it's stable but it seems to work.

Markus Rechberger wrote:
> On 3/28/08, Mat <heavensdoor78@gmail.com> wrote:
>   
> ...
> this one is connected to a usb 1.1 port .. the driver doesn't work
> with usb 1.1 (at least not yet).
>
> Is there any productlink available?
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
