Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7NDwKxO025773
	for <video4linux-list@redhat.com>; Sat, 23 Aug 2008 09:58:20 -0400
Received: from yop.chewa.net (yop.chewa.net [91.121.105.214])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7NDvsI7032306
	for <video4linux-list@redhat.com>; Sat, 23 Aug 2008 09:57:54 -0400
Date: Sat, 23 Aug 2008 15:57:53 +0200
From: Antoine Cellerier <dionoea@videolan.org>
To: video4linux-list@redhat.com
Message-ID: <20080823135753.GA15382@chewa.net>
References: <48af25c7.150.64de.2111441109@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48af25c7.150.64de.2111441109@uninet.com.br>
Subject: Re: Stretching RGB24
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

On Fri, Aug 22, 2008, danflu@uninet.com.br wrote:
> I'm looking for some library capable of performing image
> stretch in software (particularly between RGB24 formats).
> Could you please help me ? Sample codes would be very useful
> to me too !

You should give ffmpeg's libswscale a try.

-- 
Antoine Cellerier
dionoea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
