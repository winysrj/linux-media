Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVHwdKi031867
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 12:58:40 -0500
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVHwN4c011745
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 12:58:25 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: jj@ds.pg.gda.pl
In-Reply-To: <495aae6913ee57.85045613@wp.pl>
References: <495aae6913ee57.85045613@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Wed, 31 Dec 2008 18:49:55 +0100
Message-Id: <1230745795.1699.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: gspca (ubuntu 8.10) and sonixj camera problems
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

On Wed, 2008-12-31 at 00:27 +0100, Janusz Jurski wrote:
> Hi All,

Hi Janusz,

> My system configuration is as folows:
> - clean Ubuntu8.10 (live CD) - kernel 2.6.27
> - my USB sonixj camera connected - it is 0c45:612a Microdia PC Camera 
> (SN9C110)
> - dmesg shows no errors or suspicious messages
> 
> Problem: I cannot get any application to work with my camera. Even svv 
> mentioned in http://moinejf.free.fr/gspca_README.txt does not work. Logs 
> for svv and streamer are below. Attached is also a raw file generated 
> with svv (just 2kB in size). The logs show JPEG conversion errors. 
> Anyone has a similar problem? Any helpful ideas on what to do?
> 
> I appreciate your help.

Did you get the last gspca from my repository?

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
