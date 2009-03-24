Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OKqtWV008611
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 16:52:55 -0400
Received: from diomedes.noc.ntua.gr (diomedes.noc.ntua.gr [147.102.222.220])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2OKpbjZ031115
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 16:51:38 -0400
Date: Tue, 24 Mar 2009 22:51:12 +0200 (EET)
From: "Theodoros V. Kalamatianos" <thkala@softlab.ece.ntua.gr>
To: Lamarque Vieira Souza <lamarque@gmail.com>
In-Reply-To: <200903241605.07230.lamarque@gmail.com>
Message-ID: <alpine.LMD.1.10.0903242247470.17631@infinity.deepcore.ngn>
References: <200903231708.08860.lamarque@gmail.com>
	<200903241542.32631.lamarque@gmail.com>
	<d9def9db0903241158h6324e805j68682c42098648cd@mail.gmail.com>
	<200903241605.07230.lamarque@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4l
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


On Tue, 24 Mar 2009, Lamarque Vieira Souza wrote:
>>> LD_PRELOAD=/usr/lib32/libv4l2.so /opt/skype/skype
>>>
>>>        /opt/skype/skype is the binary executable. There is not error
>>> message about LD_PRELOAD or libv4l. Skype returns:
>>>
>>> Skype V4L2: Could not find a suitable capture format
>>> Skype V4L2: Could not find a suitable capture format
>>> Starting the process...
>>> Skype Xv: Xv ports available: 4
>>> Skype XShm: XShm support enabled
>>> Skype Xv: Using Xv port 131
>>> Skype Xv: No suitable overlay format found

Keep in mind that LD_PRELOAD will be silently ignored for static binaries 
and it will simply NOT WORK. Are you certain that you are not using the 
static version of Skype?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
