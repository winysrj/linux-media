Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VG2AJV015128
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 12:02:10 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.122])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4VG1cgC006995
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 12:01:38 -0400
Received: from opus ([76.184.165.27]) by cdptpa-omta03.mail.rr.com with ESMTP
	id <20080531160132.TOXO5514.cdptpa-omta03.mail.rr.com@opus>
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 16:01:32 +0000
Received: from david by opus with local (Exim 4.69)
	(envelope-from <david@opus.istwok.net>) id 1K2TWO-00034s-F8
	for video4linux-list@redhat.com; Sat, 31 May 2008 11:01:32 -0500
Resent-Message-ID: <20080531160132.GB11803@opus.istwok.net>
Date: Fri, 30 May 2008 12:18:50 -0500
From: David Engel <david@istwok.net>
To: Jason Pontious <jpontious@gmail.com>
Message-ID: <20080530171850.GA8130@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<f50b38640805300841q1a4f05c3udbf0d0f7f19cdb6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f50b38640805300841q1a4f05c3udbf0d0f7f19cdb6e@mail.gmail.com>
Cc: video4linux-list@redhat.com
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

On Fri, May 30, 2008 at 11:41:54AM -0400, Jason Pontious wrote:
> I am using the current v4l-dvb from mercurial as the latest there now has a
> feature to allow you to select the rf input for analog channels which I
> would like to have.  I upgraded to 2.6.25 in Ubuntu because of the way
> Ubuntu is currenlty handling their kernel modules doesn't allow for an easy
> compile of the drivers from mercurial.

I was not aware the input selection method had been changed again.
Thanks.  Now, I'll know to expect a conflict with my own hack when
this makes it into the mainline kernel.

Note to Michael Krufky.  I could be [probably am] missing something,
but to me it looks like there is no way to force the use of input 0
when QAM is used.

        case TUNER_PHILIPS_FCV1236D:
        {
                unsigned int new_rf;

                if (dtv_input[priv->nr])
                        new_rf = dtv_input[priv->nr];
                else
                        switch (params->u.vsb.modulation) {
                        case QAM_64:
                        case QAM_256:
                                new_rf = 1;
                                break;
                        case VSB_8:
                        default:
                                new_rf = 0;
                                break;
                        }
                simple_set_rf_input(fe, &buf[2], &buf[3], new_rf);
                break;
        }

If dtv_input is set to 0, it will be misinterpreted as autoselect and
then the use of QAM_64 or QAM_256 will make the code use input 1!

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
