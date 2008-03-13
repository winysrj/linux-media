Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DHUaff016138
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 13:30:36 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DHTvws002386
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 13:29:58 -0400
Received: by ug-out-1314.google.com with SMTP id t39so489476ugd.6
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 10:29:57 -0700 (PDT)
Date: Thu, 13 Mar 2008 17:29:51 +0000
From: Steve Dodd <anarchetic@gmail.com>
To: r bartlett <techwritebos@yahoo.com>
Message-ID: <20080313172951.441521bb@xubuntu>
In-Reply-To: <593189.25901.qm@web56404.mail.re3.yahoo.com>
References: <593189.25901.qm@web56404.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: The final inch...
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

On Wed, 12 Mar 2008 19:17:22 -0700 (PDT), r bartlett <techwritebos@yahoo.com> wrote:

> Are there any command line things I can type to tune to a particular channel and watch it for a while?  
> 
> Can I use Mplayer, Kaffeine, or Xine?

Yup - I use mplayer and (g)xine, the versions of both in Ubuntu are built with DVB support, though I find mplayer a little flaky. Copy (or link) your channels.conf to ~/.mplayer or ~/.xine, then simply start one or the other with a MRL of the form:

dvb://<channel> 

(Remember to escape spaces in the channel name with a backslash, or put the whole thing in double quotes.)

Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
