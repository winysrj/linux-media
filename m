Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TIEV3j012557
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 14:14:31 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TIEIsG015006
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 14:14:19 -0400
Message-ID: <488F5FFF.8030306@hhs.nl>
Date: Tue, 29 Jul 2008 20:22:55 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <20092.62.70.2.252.1217333416.squirrel@webmail.xs4all.nl>
	<1217353033.1692.14.camel@localhost>
In-Reply-To: <1217353033.1692.14.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: CONFIG_VIDEO_ADV_DEBUG question
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

Jean-Francois Moine wrote:
> On Tue, 2008-07-29 at 14:10 +0200, Hans Verkuil wrote:
>> Hans de Goede wrote:
>>> CONFIG_VIDEO_ADV_DEBUG enables additional debugging output in the gscpa
>>> driver, which then becomes "active" when a module option gets passed. So
>> 	[snip]
>> But the way gspca uses it is not correct. I would remove the test on
>> CONFIG_VIDEO_ADV_DEBUG there altogether, or replace it with a test of a
> 
> Hello Hans and Hans,
> 
> OK. So I see 3 options:
> 1) add a new kernel config option, say CONFIG_GSPCA_DEBUG,
> 2) always set an internal compile option GSPCA_DEBUG,
> 3) have the option GSPCA_DEBUG, but unset by default.
> 
> Which is the best for you, Hans (de Goede)?
> 

My vote goes to 2, so that when users using distro kernels (which will soon 
have gspca v2, Fedora's development kernel already has it) we can tell them to 
add the necessary module option and get debug output from them without them 
having to rebuild a kernel (module).

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
