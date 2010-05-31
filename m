Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4VBKUIF023905
	for <video4linux-list@redhat.com>; Mon, 31 May 2010 07:20:30 -0400
Received: from hedgehog.linetec.nl (208-53.bbned.dsl.internl.net
	[92.254.53.208])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4VBKGn3006248
	for <video4linux-list@redhat.com>; Mon, 31 May 2010 07:20:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by hedgehog.linetec.nl (Postfix) with ESMTP id 8B27256C5EC
	for <video4linux-list@redhat.com>;
	Mon, 31 May 2010 13:20:15 +0200 (CEST)
Received: from hedgehog.linetec.nl ([127.0.0.1])
	by localhost (hedgehog.linetec.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n7UjNyE6bP8w for <video4linux-list@redhat.com>;
	Mon, 31 May 2010 13:20:14 +0200 (CEST)
Received: from [192.168.1.13] (unknown [192.168.1.13])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hedgehog.linetec.nl (Postfix) with ESMTP id 2AF7856C5E4
	for <video4linux-list@redhat.com>;
	Mon, 31 May 2010 13:20:14 +0200 (CEST)
Subject: Newbie questions: live camera view with composite image +
	capturing images
From: Richard Rasker <rasker@linetec.nl>
To: video4linux-list@redhat.com
Date: Mon, 31 May 2010 13:20:13 +0200
Message-Id: <1275304813.5728.69.camel@localhost>
Mime-Version: 1.0
Reply-To: rasker@linetec.nl
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

SGVsbG8gYWxsLAoKSSdtIG5vdCBjZXJ0YWluIGlmIHRoaXMgaXMgdGhlIGJlc3QgcGxhY2UgdG8g
YXNrIG15IG5ld2JpZSBxdWVzdGlvbnMsCmJ1dCBpZiBpdCBpc24ndCwgSSBob3BlIHRoYXQgc29t
ZW9uZSBoZXJlIGNhbiBhdCBsZWFzdCBwb2ludCBtZSBpbiB0aGUKcmlnaHQgZGlyZWN0aW9uLgoK
SSdtIGJ1aWxkaW5nIGFuIGltYWdlIHByb2Nlc3Npbmcgc3lzdGVtIGZvciBtZWRpY2FsIHB1cnBv
c2VzOyBzaW1wbHkKc2FpZCwgaXQncyBkZXNpZ25lZCBmb3IgbW9uaXRvcmluZyB3b3VuZHMgYW5k
IHRoZWlyIGhlYWxpbmcgcHJvY2Vzcy4KTW9zdCBvZiB0aGUgYWN0dWFsIHByb2Nlc3Npbmcgd2ls
bCBpbml0aWFsbHkgYmUgZG9uZSB3aXRoIHRoZQpJbWFnZU1hZ2ljayBsaWJyYXJ5IC0tIGJ1dCB3
ZSBuZWVkIHRvIGNhcHR1cmUgaW1hZ2VzIHRvIHByb2Nlc3MsIG9mCmNvdXJzZSwg77u/Zm9yIHdo
aWNoIHdlIG9yZGVyZWQgYW4gaW5kdXN0cmlhbC10eXBlIGNhbWVyYSAodGhlIERCSyAzMUJVMDMK
ZnJvbSBUaGUgSW1hZ2luZyBTb3VyY2UsIHdpY2ggYXBwYXJlbnRseSBoYXMgVjRMMiBzdXBwb3J0
KS4KCldlIGRvbid0IGhhdmUgdGhpcyBjYW1lcmEgeWV0LCBidXQgZXhwZWN0IGl0IHRvIGFycml2
ZSB3aXRoaW4gYSB3ZWVrIC0tCnJpZ2h0IG5vdywgd2UncmUgd29ya2luZyB3aXRoIGFub3RoZXIg
Y2FtZXJhIG9uIGEgV2luZG93cyBtYWNoaW5lLCBidXQKdGhhdCdzIHNoZWVyIGhlbGw6IGxvdXN5
IHBpY3R1cmUgcXVhbGl0eSwgYnVnZ3kgY2FtZXJhIGZpcm13YXJlLCBidWdneQpjYW1lcmEgY29u
dHJvbCBzb2Z0d2FyZSwgYW5kIHRoZW4gdGhlcmUncyBXaW5kb3dzIGl0c2VsZiBnaXZpbmcgb25l
Cm5hc3R5IHN1cnByaXNlIGFmdGVyIGFub3RoZXIuIFNvIHdlIGRlY2lkZWQgdG8gdHJ5IGFuZCBt
YWtlIHRoaW5ncyB3b3JrCnVuZGVyIExpbnV4LCBvdmVyIHdoaWNoIEkgaGF2ZSBjb25zaWRlcmFi
bHkgbW9yZSBjb250cm9sIHRoYW4gV2luZG93cy4KCgpUaGUgZ29hbCBmb3Igbm93IGlzIHRvIGhh
dmUgYSBsaXZlIHN0cmVhbWluZyBjYW1lcmEgdmlldyBpbiBhIEdVSQp3aW5kb3csIG92ZXJsYWlk
IHdpdGggYSBwcmUtZXhpc3RpbmcgaW1hZ2UgKGNvbXBvc2l0ZSwgSSBiZWxpZXZlIGl0J3MKY2Fs
bGVkKTsgdGhpcyBpbWFnZSBoYXMgdGhlIHNhbWUgZGltZW5zaW9ucyBhbmQgcmVzb2x1dGlvbiBh
cyB0aGUgY2FtZXJhCnBpY3R1cmUsIGJ1dCBtdXN0IG9mIGNvdXJzZSBiZSAocGFydGlhbGx5KSB0
cmFuc3BhcmVudC4KCldlIGFsc28gd2FudCB0byB0YWtlIGltYWdlIGNhcHR1cmVzIGZyb20gdGhp
cyBzdHJlYW0sIHdpdGhvdXQgdGhlCmNvbXBvc2l0ZSBpbWFnZSB0aG91Z2guCgoKQXJlIHRoZXJl
IHNpbXBsZSB0b29scyB0byBhY2NvbXBsaXNoIHRoaXM/IEkgZm91bmQgYSBjYW1lcmEgdmlld2Vy
CmFwcGxpY2F0aW9uIGJ5IHRoZSBuYW1lIG9mIENhbW9yYW1hLCB3aGljaCBzZWVtcyB0byBmaXQg
dGhlIGJpbGwgbmljZWx5CihpdCBjYW4gYWxzbyBjcmVhdGUgY2FwdHVyZXMpLCBidXQgSSBjYW4n
dCBzZWUgaWYgaXQncyBjYXBhYmxlIG9mCmNyZWF0aW5nIHRoZSBjb21wb3NpdGUgbGl2ZSBpbWFn
ZSB3ZSBhYnNvbHV0ZWx5IHJlcXVpcmUuCkkgZm91bmQgc29tZSBvdGhlciB2aWV3ZXIgYXBwcyBv
dXQgdGhlcmUgKGUuZy4gY2FtRSksIGJ1dCBtb3N0IHNlZW0gdG8KaGF2ZSBiZWNvbWUgb2Jzb2xl
dGUgbG9uZyBhZ28uCgpPciBhbSBJIGJldHRlciBvZmYgZGl2aW5nIGludG8gdGhlIFY0TDIgc291
cmNlcyByaWdodCBhd2F5LCBhbmQgY29kZSBteQp3YXkgdG93YXJkcyBhIHNvbHV0aW9uPyBJJ20g
YWZyYWlkIHRoYXQgbXkgQyBwcm9ncmFtbWluZyBza2lsbHMgYXJlCnJhdGhlciBydXN0eSBhZnRl
ciB0d28gZGVjYWRlcywgc28gaXQgd291bGQgYmUgcHJlZmVyYWJsZSB0byBhdCBsZWFzdApzdGFy
dCBvZmYgd2l0aCBzb21lIGNydWRlIHNvbHV0aW9ucyAtLSBhbnkgcmVmaW5lbWVudHMgY2FuIGJl
IG1hZGUgaW4KdGhlIGNvdXJzZSBvZiB0aGUgZm9sbG93aW5nIG1vbnRocy4KCldlJ3JlIGFsc28g
cG9uZGVyaW5nIHRvIGhpcmUgc29tZW9uZSB3aXRoIGJldHRlciBza2lsbHMgdGhhbiBtZSBpbiB0
aGlzCnJlc3BlY3QsIHNvIGFueW9uZSBpbnRlcmVzdGVkIG1heSBhcHBseSAtLSBhbHRob3VnaCB3
ZSdyZSBwcmltYXJpbHkKbG9va2luZyBmb3Igc29tZW9uZSBoZXJlIGluIHRoZSBOZXRoZXJsYW5k
cy4KCgpBbnl3YXksIHRoYW5rcyBhbHJlYWR5IGZvciBhbnkgaGludHMgYW5kIHJlcGxpZXMsIGFu
ZCBJIGhvcGUgSSdtIG5vdAphc2tpbmcgdG9vIG11Y2ggcmlnaHQgYXdheS4KCgpXaXRoIGJlc3Qg
cmVnYXJkcywKClJpY2hhcmQgUmFza2VyCgotLQp2aWRlbzRsaW51eC1saXN0IG1haWxpbmcgbGlz
dApVbnN1YnNjcmliZSBtYWlsdG86dmlkZW80bGludXgtbGlzdC1yZXF1ZXN0QHJlZGhhdC5jb20/
c3ViamVjdD11bnN1YnNjcmliZQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vdmlkZW80bGludXgtbGlzdA==
