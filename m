Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77Hav7L022540
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:36:57 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77HaiQO014322
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:36:45 -0400
Received: by mu-out-0910.google.com with SMTP id w8so848017mue.1
	for <video4linux-list@redhat.com>; Thu, 07 Aug 2008 10:36:43 -0700 (PDT)
From: Eddi De Pieri <eddi@depieri.net>
To: Worik <worik.stanton@gmail.com>
In-Reply-To: <1218078525.7497.2.camel@kupe>
References: <1205053694.6188.312.camel@gloria.red.sld.cu>
	<1217992008.8094.17.camel@kupe>  <1218052304.7377.1.camel@localhost>
	<1218078525.7497.2.camel@kupe>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 19:36:38 +0200
Message-Id: <1218130598.7276.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Setting up a Xceive XC2028
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

Try simply:

hg clone http://.../tm6010 tm6010-upstream
cd tm6010-upstream
make && sudo make install

Regards
Eddi

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
