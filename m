Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6OGdQJE007489
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 12:39:26 -0400
Received: from mail.linsys.ca (205-200-74-130.static.mts.net [205.200.74.130])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6OGd7Y9028562
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 12:39:13 -0400
Received: from localhost.localdomain by linsys.ca (MDaemon PRO v9.6.6)
	with ESMTP id md50000269418.msg
	for <video4linux-list@redhat.com>; Thu, 24 Jul 2008 11:38:19 -0500
Message-ID: <4888AF8B.9030609@linsys.ca>
Date: Thu, 24 Jul 2008 11:36:27 -0500
From: Dinesh Bhat <dbhat@linsys.ca>
MIME-Version: 1.0
To: Video-4l-list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: V4L for DVB ASI
Reply-To: dbhat@linsys.ca
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

Hello,

We are DVB ASI PCI/PCIe card manufacturers in Canada. Some of you may 
have heard about our distributors: DVEO/Computer Modules. We encourage 
open source and use open source to develop our Linux products. I have 
been doing some research on getting our already open sourced DVB ASI 
drivers to work with either v4l or the regular DVB API.

I had asked a question to the community a while ago and have had few 
responses. The question was mainly to find out if there is any interest 
in the community towards this goal. We will be happy to work with you. 
The initial response was to work on v4l as opposed to the DVB API. Since 
the cards support PID filtering and other transport stream analysis, I 
am encouraged to use DVB API instead of V4L because of TS feature 
support at the software level. But then I could be wrong since I have 
not done a lot of research on these two APIs. Sigmund Augdal had listed 
out the pros and cons to my previous question:

Use the DVB Api:
pros:
 * you can take advantage of the software pid and section filters in the
dvb framework
 * if your device supports hardware pid/section filters, apis will be
available to take advantage of them
 * userspace applications that handle mpeg2 ts often use this api, and
would be easy to adapt.
cons:
 * you might need to extend the apis to handle asi cards

Use the v4l2 api:
pros:
 * semantics are well defined.
 * provides an extensible api using so called "controls"
cons:
 * adapting user space applications will be more difficult
 * no reuse of software filters

If Anybody wants to look at the drivers, they are available at http://www.linsys.ca in customer support section.

Thanks for any advice and help.

Kind Regards,

Dinesh

-- 
Linear Systems Ltd
Unit 1, 1717 Dublin Ave
Winnipeg, Manitoba, R3H 0H2
Canada
Ph:204-632-4300 Extn: 30
Fx: 204-697-2417
www.linsys.ca

CONFIDENTIALITY WARNING

The information contained in the e-mail and any documents or attachments accompanying this transmission are private and confidential and intended for the specific individual, or group, or entity named in the recipient fields of this message.  If the reader of this message is not the intended recipient, or the authorized agent thereof, the reader is hereby notified that any dissemination, distribution or copying of this transmission is strictly prohibited.  If you have received this communication in error, please notify us immediately by telephone at 204-632-4300 and delete all copies of the original message. No warranties are made or implied in this communication. Thank you. 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
