Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 26 Feb 2008 08:38:39 -0500
From: Alan Cox <alan@redhat.com>
To: Michel Bardiaux <mbardiaux@mediaxim.be>, video4linux-list@redhat.com
Message-ID: <20080226133839.GE26389@devserv.devel.redhat.com>
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226130200.GA215@daniel.bse>
Cc: 
Subject: Re: Grabbing 4:3 and 16:9
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

On Tue, Feb 26, 2008 at 02:02:00PM +0100, Daniel Glöckner wrote:
> > 2. How do I setup the bttv so that it does variable anamorphosis instead 
> > of letterboxing? If that is at all possible of course...
> 
> You can't. Bttv can't stretch vertically.

Use an OpenGL texture is probably the easiest for that kind of effect.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
