Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7BJpnKR028085
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 15:51:49 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7BJpRTq023160
	for <video4linux-list@redhat.com>; Wed, 11 Aug 2010 15:51:29 -0400
Message-ID: <4C62FF3E.4060300@tmr.com>
Date: Wed, 11 Aug 2010 15:51:26 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: Bill Davidsen <davidsen@posidon.tmr.com>,
        video4linux M/L <video4linux-list@redhat.com>
Subject: VIDEO: [FFmpeg-user] question about adding video stream from one
	still	image
Content-Type: multipart/mixed; boundary="------------080505000209030208010103"
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------080505000209030208010103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein


--------------080505000209030208010103
Content-Type: message/rfc822;
	name="Re: [FFmpeg-user] question about adding video stream from one
	still	image.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="Re: [FFmpeg-user] question about adding video stream from
	on"; filename*1="e still	image.eml"

X-Account-Key: account8
X-Mozilla-Keys: $label5 
Return-Path: <ffmpeg-user-bounces@mplayerhq.hu>
Received: from natsuki.mplayerhq.hu (natsuki.mplayerhq.hu [213.144.138.186])
	by firewall2.tmr.com (8.13.6/8.12.8) with ESMTP id o7BGBU35026046
	for <davidsen@tmr.com>; Wed, 11 Aug 2010 12:11:31 -0400
Received: from natsuki.mplayerhq.hu (localhost.localdomain [127.0.0.1])
	by natsuki.mplayerhq.hu (Postfix) with ESMTP id B4C913B4CF;
	Wed, 11 Aug 2010 18:11:29 +0200 (CEST)
X-Original-To: ffmpeg-user@mplayerhq.hu
Delivered-To: ffmpeg-user@mplayerhq.hu
Received: from localhost (localhost.localdomain [127.0.0.1])
	by natsuki.mplayerhq.hu (Postfix) with ESMTP id 2A7C43B4CC
	for <ffmpeg-user@mplayerhq.hu>; Wed, 11 Aug 2010 18:11:27 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mplayerhq.hu
Received: from natsuki.mplayerhq.hu ([127.0.0.1])
	by localhost (natsuki.mplayerhq.hu [127.0.0.1]) (amavisd-new,
	port 10024) with LMTP id iChl57a5XdEF for <ffmpeg-user@mplayerhq.hu>;
	Wed, 11 Aug 2010 18:11:27 +0200 (CEST)
Received: from mail-qw0-f47.google.com (mail-qw0-f47.google.com
	[209.85.216.47])
	by natsuki.mplayerhq.hu (Postfix) with ESMTP id CC9433B4CB
	for <ffmpeg-user@mplayerhq.hu>; Wed, 11 Aug 2010 18:11:26 +0200 (CEST)
Received: by qwg8 with SMTP id 8so295192qwg.6
	for <ffmpeg-user@mplayerhq.hu>; Wed, 11 Aug 2010 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:mime-version:received:received:in-reply-to
	:references:date:message-id:subject:from:to:content-type;
	bh=nhs1r+BiJJ66jL2ybSYdBr36bprgE1zDbAcQcFkitUE=;
	b=cewe5fq8p2LEpF+PIgP237QHJ+w9X+yQho3sBchdO3mxyE2oKS91gorLToQRzveo7D
	lvMHFLL6RgjRmg+FFbfgQHGQMDv/QxcK6/BCjZVzx1VzsRvzYwQTPM97xKJkURX9AkpD
	4B4dMQzaC3kUh2vgYJHI+flDRdT4xxdGddE9w=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=gmail.com; s=gamma;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to
	:content-type;
	b=fZurXBGrN5QmrNBHFupepFqM5T9X4/1lumQOhe5XUCqrJZUvGfwKD5HjcWEoFgQG8w
	3wL8jUPLhTyI/cIabWshUjZUmvsDOa+PVUCV1D5R49SqDboLk1i32J1DfNCJtEiDg7yp
	9KU3DARwSAhVHDm8CwGh187HR87YSZwfLnkAQ=
MIME-Version: 1.0
Received: by 10.224.28.209 with SMTP id n17mr511045qac.34.1281543086050; Wed,
	11 Aug 2010 09:11:26 -0700 (PDT)
Received: by 10.229.17.11 with HTTP; Wed, 11 Aug 2010 09:11:26 -0700 (PDT)
In-Reply-To: <20100811174520.GB3683@laptop.gs>
References: <20100811174520.GB3683@laptop.gs>
Date: Wed, 11 Aug 2010 18:11:26 +0200
Message-ID: <AANLkTikfK5+qZNyLtsUikYkbpGU8yDB+7x_mdMvmNf5D@mail.gmail.com>
From: James Darnley <james.darnley@gmail.com>
To: FFmpeg user questions and RTFMs <ffmpeg-user@mplayerhq.hu>
Subject: Re: [FFmpeg-user] question about adding video stream from one still
	image
X-BeenThere: ffmpeg-user@mplayerhq.hu
X-Mailman-Version: 2.1.11
Precedence: list
Reply-To: FFmpeg user questions and RTFMs <ffmpeg-user@mplayerhq.hu>
List-Id: FFmpeg user questions and RTFMs <ffmpeg-user.mplayerhq.hu>
List-Unsubscribe: <https://lists.mplayerhq.hu/mailman/options/ffmpeg-user>,
	<mailto:ffmpeg-user-request@mplayerhq.hu?subject=unsubscribe>
List-Archive: <http://lists.mplayerhq.hu/pipermail/ffmpeg-user>
List-Post: <mailto:ffmpeg-user@mplayerhq.hu>
List-Help: <mailto:ffmpeg-user-request@mplayerhq.hu?subject=help>
List-Subscribe: <https://lists.mplayerhq.hu/mailman/listinfo/ffmpeg-user>,
	<mailto:ffmpeg-user-request@mplayerhq.hu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ffmpeg-user-bounces@mplayerhq.hu
Errors-To: ffmpeg-user-bounces@mplayerhq.hu

Perhaps you want -shortest
_______________________________________________
ffmpeg-user mailing list
ffmpeg-user@mplayerhq.hu
https://lists.mplayerhq.hu/mailman/listinfo/ffmpeg-user


--------------080505000209030208010103
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080505000209030208010103--
