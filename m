Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m517FeSl025431
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:15:40 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m517FUlc026328
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 03:15:30 -0400
Received: by yw-out-2324.google.com with SMTP id 5so215688ywb.81
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 00:15:30 -0700 (PDT)
Message-ID: <37219a840806010015i342f324dl3a9849579d2defb5@mail.gmail.com>
Date: Sun, 1 Jun 2008 03:15:30 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "David Engel" <david@istwok.net>
In-Reply-To: <20080530171850.GA8130@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<f50b38640805300841q1a4f05c3udbf0d0f7f19cdb6e@mail.gmail.com>
	<20080530171850.GA8130@opus.istwok.net>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
Subject: Re: Kworld 115-No Analog Channels
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

On Fri, May 30, 2008 at 1:18 PM, David Engel <david@istwok.net> wrote:
> On Fri, May 30, 2008 at 11:41:54AM -0400, Jason Pontious wrote:
>> I am using the current v4l-dvb from mercurial as the latest there now has a
>> feature to allow you to select the rf input for analog channels which I
>> would like to have.  I upgraded to 2.6.25 in Ubuntu because of the way
>> Ubuntu is currenlty handling their kernel modules doesn't allow for an easy
>> compile of the drivers from mercurial.
>
> I was not aware the input selection method had been changed again.
> Thanks.  Now, I'll know to expect a conflict with my own hack when
> this makes it into the mainline kernel.
>
> Note to Michael Krufky.  I could be [probably am] missing something,
> but to me it looks like there is no way to force the use of input 0
> when QAM is used.
>
>        case TUNER_PHILIPS_FCV1236D:
>        {
>                unsigned int new_rf;
>
>                if (dtv_input[priv->nr])
>                        new_rf = dtv_input[priv->nr];
>                else
>                        switch (params->u.vsb.modulation) {
>                        case QAM_64:
>                        case QAM_256:
>                                new_rf = 1;
>                                break;
>                        case VSB_8:
>                        default:
>                                new_rf = 0;
>                                break;
>                        }
>                simple_set_rf_input(fe, &buf[2], &buf[3], new_rf);
>                break;
>        }
>
> If dtv_input is set to 0, it will be misinterpreted as autoselect and
> then the use of QAM_64 or QAM_256 will make the code use input 1!


David,

"1" is tuner 1
"2" is tuner 2  (actually, "not one" is tuner "not one")
"0" is autoselect

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
