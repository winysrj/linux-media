Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB7CmqJZ027111
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 07:48:52 -0500
Received: from smtp-vbr8.xs4all.nl (smtp-vbr8.xs4all.nl [194.109.24.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB7CmYAE005935
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 07:48:34 -0500
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id mB7CmTEK099597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Sun, 7 Dec 2008 13:48:33 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Sun, 7 Dec 2008 13:48:28 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071348.28510.hverkuil@xs4all.nl>
Subject: Building v4l2spec docbook problems
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

Hi all,

I'm trying to build the v4l2spec: 
http://v4l2spec.bytesex.org/v4l2spec-0.24.tar.bz2

But I'm getting the following errors:

...
Using catalogs: /etc/sgml/catalog
Using stylesheet: /home/hans/work/src/v4l2spec-0.24/custom.dsl#html
Working on: /home/hans/work/src/v4l2spec-0.24/v4l2.sgml
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:5:W: cannot 
generate system identifier for general entity "sub-common"
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:5:E: general 
entity "sub-common" not defined and no default entity
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:15:E: reference to 
entity "sub-common" for which no system identifier could be generated
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:357:4: entity was 
defined here
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:358:11:E: end tag 
for "CHAPTER" which is not finished
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:5:W: cannot 
generate system identifier for general entity "sub-pixfmt"
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:5:E: general 
entity "sub-pixfmt" not defined and no default entity
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:15:E: reference to 
entity "sub-pixfmt" for which no system identifier could be generated
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:361:4: entity was 
defined here
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:362:11:E: end tag 
for "CHAPTER" which is not finished
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:5:W: cannot 
generate system identifier for general entity "sub-io"
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:5:E: general 
entity "sub-io" not defined and no default entity
jade:/home/hans/work/src/v4l2spec-0.24/v4l2.sgml:365:11:E: reference to 
entity "sub-io" for which no system identifier could be generated

And this continues for a long list of 'sub-something' entities.

Me no speak sgml, so I hope someone more familiar with this can help me.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
