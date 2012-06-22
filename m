Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37697 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab2FVEwj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 00:52:39 -0400
Message-ID: <1340340750.6871.212.camel@deadeye.wl.decadent.org.uk>
Subject: [3.2->3.3 regression] mceusb: only every second keypress is
 recognised
From: Ben Hutchings <ben@decadent.org.uk>
To: Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: 677727@bugs.debian.org, Michael Schmitt <tcwardrobe@gmail.com>
Date: Fri, 22 Jun 2012 05:52:30 +0100
In-Reply-To: <4FDF2B39.1000402@gmail.com>
References: <20120616142624.11863.63977.reportbug@ganymed.tcw.local>
	 <1339865057.4942.184.camel@deadeye.wl.decadent.org.uk>
	 <4FDE4C13.8030308@gmail.com>
	 <1339978963.4942.273.camel@deadeye.wl.decadent.org.uk>
	 <4FDF2B39.1000402@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jWyJWyaIN/0XeUQjxFC/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jWyJWyaIN/0XeUQjxFC/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[Full bug log is at <http://bugs.debian.org/677727>.]

On Mon, 2012-06-18 at 15:20 +0200, Michael Schmitt wrote:
> Hi Ben,
>=20
> mschmitt@ganymed:~$ dmesg |head -3
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.3.0-rc6-686-pae (Debian=20
> 3.3~rc6-1~experimental.1) (debian-kernel@lists.debian.org) (gcc version=
=20
> 4.6.3 (Debian 4.6.3-1) ) #1 SMP Mon Mar 5 21:21:52 UTC 2012
>=20
> that is the first kernel I found on snapshot.d.o that does show that=20
> issue. The next one backwards is "linux-image-3.2.0-2-686-pae=20
> (3.2.20-1)" and that one works.
>=20
> Is there anything that comes to your mind?

No, but this version information should help to track down how the bug
was introduced.

Michael originally wrote:
> with the current kernel from experimental only every second keypress is
> recognized on my ir remote control. Reboot to kernel 3.2 from sid, all ba=
ck to
> normal.
> I have no idea how the kernel could be responsible there... ok, a weird b=
ug in
> the responsible kernel module for the remote, but somehow I doubt that.

The driver in question is mceusb.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-jWyJWyaIN/0XeUQjxFC/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+P6Due/yOyVhhEJAQoQ8Q/9Gy1cxOZC4Cv9R8WGQ3XGIQ/tX4UkZscR
kT8+xkm0nUgjcx5ReWMljR+/J/JQG1w0TA+3VUmota/JnwpnlWfF8YgS5KlQBYRj
REqHAn6YmqBB7uZA5dauyllds5cM64xHoDA4xW8VbmqwGpF1aWPnez+GWWcipreZ
3JwiCbxmHA1z4iPMd2kcmOU2QNvm+Oh0WhKAI8BJpHVlg43Ph69zDWzcNdyu7EKH
f9GoKZQ8ZQDLcsLnrsbuHGTc3X/ctn+SHlgLb02pmkp8eAhIX2Oj2KOxbvIaeoo5
0Ih82U5+CElmUk9rgQE5sQc+nx4zF49lYfa2k5oCJJXqG6SOQw0yPQTYopTVckRR
7tUGA+0+pYwAlawhBl9IQjaAgDNmQf113gmjARmaP1JX/paDQdJW0RmAKCutff9y
xgD10q/3PnaVRfqGuYoKDPNJLxFioBSmRedA7w9/dVrYj2tHOUKWUWv5jKy+PEg8
O/6RJs4oljaWozyrmeVYLqgOJqjTnfjigI+lzE3kHNucLf47UeKhoKEk632meyPI
nG3aqYt4q5HSUGMrJMYDY7VVz8IDc/uRVi5f/jPSY2xFf+HnrNFTCRkqLgtNgHLo
MRO+OUWSvnqnhqKSeY2cwozweXDJFtqN8WdQ1DPwsZFgO4Ce0InBsLDOAiKujwqF
RfVlHzUPtgU=
=aw8/
-----END PGP SIGNATURE-----

--=-jWyJWyaIN/0XeUQjxFC/--
