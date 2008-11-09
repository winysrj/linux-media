Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9IrKRW025404
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 13:53:20 -0500
Received: from bar.sig21.net (bar.sig21.net [88.198.146.85])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9IqaRB008579
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 13:52:36 -0500
Date: Sun, 9 Nov 2008 19:52:49 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: CityK <cityk@rogers.com>
Message-ID: <20081109185249.GC8551@linuxtv.org>
References: <490525EA.4020608@rogers.com> <20081028152152.GA22100@linuxtv.org>
	<49164A6F.50904@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49164A6F.50904@rogers.com>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [Bulk] Re: [linux-dvb] Announcement: wiki merger and some
	loose ends
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

On Sat, Nov 08, 2008 at 09:26:55PM -0500, CityK wrote:
> 
> Okay, thanks. First request: When you have some free time, can you look
> into setting up a "V4L:" namespace please. See relevant pages below (I
> 've tried, but I can't figure out how to edit the LocalSettings.php file
> -- apparently I'm not the only one; see last link).
> 
> http://www.mediawiki.org/wiki/Manual:Namespace
> http://www.mediawiki.org/wiki/Manual:Using_custom_namespaces
> http://www.mediawiki.org/wiki/Manual:$wgExtraNamespaces
> http://www.mediawiki.org/wiki/Manual:LocalSettings.php
> http://www.mediawiki.org/wiki/Manual_talk:LocalSettings.php#Where_is_this_file.3F

http://www.mediawiki.org/wiki/Manual:Using_custom_namespaces#Why_you_would_want_a_custom_namespace
  A custom namespace can be used to hold content that should not be shown
  on the search results page.

http://www.mediawiki.org/wiki/Manual:$wgNamespacesToBeSearchedDefault
  Note that changing these values in LocalSettings.php only affects newly
  created and anonymous users - it does not change the settings for existing
  users.

That sounds rather cumbersome. My feeling is that MediaWiki namespaces
are not meant to be used for separating main content, but only for
separating secondary pages like in the technical support example.

Are you sure you want this?


Johannes

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
